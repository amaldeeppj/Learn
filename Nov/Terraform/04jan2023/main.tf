# VPC creation

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-${var.environment}"
  }

}


# Internat Gateway creation

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

# Creation of 2 public subnets for deploying bastion and web servers 

resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, "${count.index}")
  availability_zone       = data.aws_availability_zones.available.names["${count.index}"]

  tags = {
    Name = "${var.project}-${var.environment}-public-${substr(data.aws_availability_zones.available.names["${count.index}"], -2, 2)}"
  }
}


# Creation of 1 private subnet for deploying database servers

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 2)
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project}-${var.environment}-private-1a"
  }
}

# Creation of elastic IP to attach with NAT gateway

resource "aws_eip" "eip" {
  vpc = true

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

# Creation of NAT gateway (To avail internet for the instances inside private subnet)

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    "Name" = "${var.project}-${var.environment}"
  }

}

# Creation of public route

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "${var.project}-${var.environment}-public"
  }

}

# Creation of private route 

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "${var.project}-${var.environment}-private"
  }
}

# Public route table association with public subnets

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets["${count.index}"].id
  route_table_id = aws_route_table.public_route.id
}


# Private route table association with private subnets

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

# Create security group for bastion server 

resource "aws_security_group" "bastion_sg" {
  name_prefix = "${var.project}-${var.environment}-bastion-"
  description = "Allow SSH access to bastion server"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
  vpc_id      = aws_vpc.vpc.id



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
  vpc_id      = aws_vpc.vpc.id

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
  vpc_id      = aws_vpc.vpc.id

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


# Create DB instance

resource "aws_instance" "database-test" {

  count = var.environment == "test" ? 1 : 0

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.test_ssh_key
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.db_sg.id]
  user_data                   = data.template_file.db_credentials.rendered
  user_data_replace_on_change = true
  depends_on = [
    aws_nat_gateway.nat,
    aws_route_table_association.private
  ]

  tags = {
    Name = "${var.project}-${var.environment}-database-test"

  }

}

resource "aws_instance" "database-stage" {

  count = var.environment == "stage" ? 1 : 0

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.stage_ssh_key
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.db_sg.id]
  user_data                   = data.template_file.db_credentials.rendered
  user_data_replace_on_change = true
  depends_on = [
    aws_nat_gateway.nat,
    aws_route_table_association.private
  ]

  tags = {
    Name = "${var.project}-${var.environment}-database-stage"

  }

}

# Create bastion instance

resource "aws_instance" "bastion" {

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  subnet_id                   = aws_subnet.public_subnets[0].id
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
  subnet_id                   = aws_subnet.public_subnets[1].id
  vpc_security_group_ids      = [aws_security_group.internalssh_sg.id, aws_security_group.web_sg.id]
  user_data                   = data.template_file.db_credentials_frontend.rendered
  user_data_replace_on_change = true
  depends_on = [
    aws_instance.database-test[0],
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
    vpc_id = aws_vpc.vpc.id
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
  records = [aws_instance.database-test[0].private_ip]
  depends_on = [
    aws_instance.database-test[0]
  ]
}

