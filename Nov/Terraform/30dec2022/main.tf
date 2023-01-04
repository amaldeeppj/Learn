resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-${var.environment}"
  }

}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

resource "aws_subnet" "this_public" {
  count                   = local.azs
  vpc_id                  = aws_vpc.this_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, "${count.index}")
  availability_zone       = data.aws_availability_zones.available.names["${count.index}"]

  tags = {
    Name = "${var.project}-${var.environment}-public-${substr(data.aws_availability_zones.available.names["${count.index}"], -2, 2)}"
  }
}

resource "aws_subnet" "this_private" {
  count                   = local.azs
  vpc_id                  = aws_vpc.this_vpc.id
  map_public_ip_on_launch = false
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, "${sum([count.index, local.azs])}")
  availability_zone       = data.aws_availability_zones.available.names["${count.index}"]

  tags = {
    Name = "${var.project}-${var.environment}-private-${substr(data.aws_availability_zones.available.names["${count.index}"], -2, 2)}"
  }

}


resource "aws_eip" "this_eip" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc   = true

  depends_on = [
    aws_internet_gateway.this_igw
  ]

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

resource "aws_nat_gateway" "this_nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.this_eip[0].id
  subnet_id     = aws_subnet.this_public[1].id

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

resource "aws_route_table" "this_public_route" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_igw.id
  }

  tags = {
    "Name" = "${var.project}-${var.environment}-public"
  }

}

resource "aws_route_table" "this_private_route" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this_nat[0].id
  }

  tags = {
    "Name" = "${var.project}-${var.environment}-private"
  }
}

resource "aws_route_table_association" "this_public" {
  count          = local.azs
  subnet_id      = aws_subnet.this_public["${count.index}"].id
  route_table_id = aws_route_table.this_public_route.id
}


resource "aws_route_table_association" "this_private" {
  count          = var.enable_nat_gateway ? local.azs : 0
  subnet_id      = aws_subnet.this_private["${count.index}"].id
  route_table_id = aws_route_table.this_private_route[0].id
}


resource "aws_security_group" "bastion_sg" {
  name_prefix = "${var.project}-${var.environment}-bastion-"
  description = "Allow SSH access to bastion"
  vpc_id      = aws_vpc.this_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
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

resource "aws_security_group" "webserver_sg" {
  name_prefix = "${var.project}-${var.environment}-web-"
  description = "Allow connection access to webserver"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
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

resource "aws_security_group" "dbserver_sg" {
  name_prefix = "${var.project}-${var.environment}-db-"
  description = "Allow connection access to dbserver"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-db"
  }
}

resource "aws_security_group" "internalssh_sg" {
  name_prefix = "${var.project}-${var.environment}-internal-ssh-"
  description = "Allow internal ssh connection"
  vpc_id      = aws_vpc.this_vpc.id

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
    security_groups = [aws_security_group.bastion_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-internal-ssh"
  }
}


# resource "aws_instance" "this_ec2" {
#   for_each                    = local.instances
#   ami                         = var.ami
#   instance_type               = var.instance_type
#   key_name                    = var.ssh_key
#   subnet_id                   = each.value.subnet
#   vpc_security_group_ids      = each.value.security_groups
#   user_data                   = each.value.userdata ? file(each.value.userdata_file) : null
#   user_data_replace_on_change = true
#   #   depends_on = [
#   #     each.value.depends
#   #   ]

#   tags = {
#     Name = "${var.project}-${var.environment}-${each.key}"

#   }

# }

resource "aws_instance" "database" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = aws_subnet.this_private[0].id
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.dbserver_sg.id]
  user_data                   = file("database.sh")
  user_data_replace_on_change = true
  depends_on = [
    aws_nat_gateway.this_nat
  ]

  tags = {
    Name = "${var.project}-${var.environment}-database"

  }

}


resource "aws_instance" "bastion" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = aws_subnet.this_public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  user_data_replace_on_change = true


  tags = {
    Name = "${var.project}-${var.environment}-bastion"

  }

}

resource "aws_instance" "webserver" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = aws_subnet.this_public[1].id
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.webserver_sg.id]
  user_data                   = file("frontend.sh")
  user_data_replace_on_change = true
  depends_on = [
    aws_instance.database, 
    aws_route53_record.db
  ]

  tags = {
    Name = "${var.project}-${var.environment}-webserver"

  }

}


resource "aws_route53_zone" "private" {
  name = "private.amaldeep.tech"

  vpc {
    vpc_id = aws_vpc.this_vpc.id 
  }
  
}

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

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.private.amaldeep.tech"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.database.private_ip]
  depends_on = [
    aws_instance.database
  ]
}


