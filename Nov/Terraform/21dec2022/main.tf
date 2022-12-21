# Create VPC

resource "aws_vpc" "new_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "zomato_prod"
    project = "zomato"
    env     = "production"
  }

}

# Create one subnet 

resource "aws_subnet" "new_subnet" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = cidrsubnet(var.cidr, 8, 1)
  availability_zone = var.az
  map_public_ip_on_launch = true

  tags = {
    Name    = "zomato_prod_web"
    project = "zomato"
    env     = "production"
  }

}


# Create 2 security groups 

resource "aws_security_group" "allow_https" {

  name        = "allow_http_s"
  description = "allow http and https"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "allow_http_s"
    project = "zomato"
    env     = "production"
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allow ssh"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "ssh port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "allow_ssh"
    project = "zomato"
    env     = "production"
  }

}


# curl http://169.254.169.254/latest/meta-data/ami-id
# ami-0cca134ec43cf708f

# Create EC2 instance 

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "devops"
  subnet_id              = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_https.id, aws_security_group.allow_ssh.id]

  tags = {
    Name    = "webserver"
    project = "zomato"
    env     = "production"
  }

}
