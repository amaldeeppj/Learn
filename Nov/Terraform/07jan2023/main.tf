module "vpc" {
    source = "git@github.com:amaldeeppj/VPC-Terraform.git?ref=v3"
    vpc_cidr = var.vpc_cidr
    project = var.project   
    environment = var.environment
    enable_nat_gateway = var.enable_nat_gateway
}

# Create prefix list 

resource "aws_ec2_managed_prefix_list" "prefix_list" {
    name = "${var.project}-${var.environment}-prefix-list"
    address_family = "IPv4"
    max_entries = length(var.prefix_list)

    dynamic "entry" {
        for_each = toset(var.prefix_list)
        iterator = cidr 

        content {
          cidr = cidr.value
          description = "CIDR from variable prefix_list"
        }
      
    }

    tags = {
      "Name" = "${var.project}-${var.environment}-prefix-list"
    }

  
}

# Create security group for bastion server 

resource "aws_security_group" "bastion_sg" {
  name_prefix = "${var.project}-${var.environment}-bastion-"
  description = "Allow SSH access to bastion server from prefix list"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = var.enable_public_ssh ? ["0.0.0.0/0"] : null
    prefix_list_ids = [aws_ec2_managed_prefix_list.prefix_list.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-bastion"
  }
}

# Create security group for web server 

resource "aws_security_group" "web_sg" {
  name_prefix = "${var.project}-${var.environment}-web-"
  description = "Allow access to web server"
  vpc_id      = module.vpc.vpc_id



  dynamic "ingress" {
    for_each = toset(var.webserver_ports)
    iterator = web_port
    content {
      from_port        = web_port.value
      to_port          = web_port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]

    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-web"
  }
}

# Create security group for DB server 

resource "aws_security_group" "db_sg" {
  name_prefix = "${var.project}-${var.environment}-db-"
  description = "Allow db connection"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-db"
  }
}


# Security group for allowing SSH connections from bastion server

resource "aws_security_group" "internalssh_sg" {
  name_prefix = "${var.project}-${var.environment}-internal-ssh-"
  description = "Allow internal ssh connection"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = var.enable_public_ssh ? ["0.0.0.0/0"] : null
    security_groups = [aws_security_group.bastion_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-internal-ssh"
  }
}

# Create PEM file

resource "tls_private_key" "ssh_key" {
    count = var.use_existing_key ? 0 : 1
    algorithm = "RSA"
    rsa_bits = 4096
  
}

# Upload generated key and save pem file

resource "aws_key_pair" "key_pair" {
    count = var.use_existing_key ? 0 : 1
    key_name = var.ssh_key
    public_key = tls_private_key.ssh_key[0].public_key_openssh

    provisioner "local-exec" {
        command = "echo '${tls_private_key.ssh_key[0].private_key_pem}' > '${path.module}'/'${var.ssh_key}'.pem"
             
    }

    provisioner "local-exec" {
        command = "chmod 400 '${path.module}'/'${var.ssh_key}'.pem"
      
    }
  
      provisioner "local-exec" {
        when = destroy
        
        # command = "rm -f '${path.module}'/'${var.ssh_key}'.pem"   ## Gives following error
        # Destroy-time provisioners and their connection configurations may only reference attributes of the related resource, 
        # via 'self', 'count.index', or 'each.key'.
        # References to other resources during the destroy phase can cause dependency cycles 
        # and interact poorly with create_before_destroy.
        
        command = "rm -f ./'${self.key_name}'.pem"
        working_dir = path.module
      
    }
}


# Create database instance

resource "aws_instance" "database" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.db_sg.id]
  user_data                   = data.template_file.db_credentials.rendered
  user_data_replace_on_change = true
  
  depends_on = [
    module.vpc
  ]

  tags = {
    Name = "${var.project}-${var.environment}-database"

  }

}

# Create bastion instance

resource "aws_instance" "bastion" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  user_data_replace_on_change = true


#   provisioner "file" {
#         source = "./${var.ssh_key}.pem"
#         destination = "/home/ec2-user/${var.ssh_key}.pem"

#         connection {
#           type = "ssh"
#           user = "ec2-user"
#           private_key = "${file("${path.module}/${var.ssh_key}.pem")}"
#           host = self.public_ip
#         }
    
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod 400 /home/ec2-user/${var.ssh_key}.pem"
#     ]
    
#     connection {
#           type = "ssh"
#           user = "ec2-user"
#           private_key = "${file("${path.module}/${var.ssh_key}.pem")}"
#           host = self.public_ip
#         }

#   }

  tags = {
    Name = "${var.project}-${var.environment}-bastion"

  }

}

# Create webserver instance

resource "aws_instance" "webserver" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = module.vpc.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.web_sg.id]
  user_data                   = data.template_file.db_credentials_frontend.rendered
  user_data_replace_on_change = true
  depends_on = [
    aws_instance.database,
    aws_route53_record.db
  ]

  tags = {
    Name = "${var.project}-${var.environment}-webserver"

  }

}


# Create private zone for db servers

resource "aws_route53_zone" "private" {
  name = var.private_zone

  vpc {
    vpc_id = module.vpc.vpc_id
  }

}

# Create A record for webserver

resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "wordpress.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.webserver.public_ip]
  depends_on = [
    aws_instance.webserver
  ]
}

# Create A record of DB server

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${var.private_zone}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.database.private_ip]
  depends_on = [
    aws_instance.database
  ]
}


resource "null_resource" "bastion" {
  triggers = {
    # triggers when instance id changes. 
    instance_id = aws_instance.bastion.id
  }
  
  count = var.use_existing_key ? 0 : 1

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${path.module}/${var.ssh_key}.pem")}"
    host = aws_instance.bastion.public_ip
  }

  provisioner "file" {
        source = "${path.module}/${var.ssh_key}.pem"
        destination = "/home/ec2-user/${var.ssh_key}.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ec2-user/${var.ssh_key}.pem"
    ]
  } 

  provisioner "local-exec" {

    command = "echo ssh -i '${path.module}'/'${var.ssh_key}'.pem ec2-user@'${aws_instance.bastion.public_ip}' > '${path.module}'/ssh_command.txt"
    
  }

}

