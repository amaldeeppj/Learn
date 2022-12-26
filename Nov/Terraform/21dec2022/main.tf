# Create key-pair

resource "aws_key_pair" "new-key" {
  key_name   = "${var.project}-${var.environment}-key"
  public_key = file(var.access-key)

  tags = {
    Name        = "${var.project}-${var.environment}-key"
    # project     = var.project
    # environment = var.environment
  }
}


# Create VPC

resource "aws_vpc" "new_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "zomato_prod"
    # project = "zomato"
    # env     = "production"
  }

}

# Create internet gateway 

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-internet-gateway"
    # project = "${var.project}"
    # env     = "${var.environment}"
  }  
  
}

# Create route tables

resource "aws_route_table" "internet-access" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name    = "${var.project}-${var.environment}-route-table"
    # project = "${var.project}"
    # env     = "${var.environment}"
  }

}

# Create one subnet 

resource "aws_subnet" "new_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = cidrsubnet(var.cidr, 8, 1)
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name    = "zomato_prod_web"
    # project = "zomato"
    # env     = "production"
  }

}

# Route table associaton > make subnet public

resource "aws_route_table_association" "route-table-associate" {
  subnet_id = aws_subnet.new_subnet.id
  route_table_id = aws_route_table.internet-access.id
  
}

# Create 2 security groups 

resource "aws_security_group" "allow_https" {

  # name        = "${var.project}-${var.environment}-webserver-access-sg"
  name_prefix = "${var.project}-${var.environment}-webserver-access-sg-"
  description = "allow webserver access for port 80 and port 443"
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

  egress {
    description      = "allow internet access"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-webserver-sg"
    # project = "${var.project}"
    # env     = "${var.environment}"
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "${var.project}-${var.environment}-ssh-sg"
  description = "allow ssh access"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "ssh port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-ssh-sg"
    # project = "${var.project}"
    # env     = "${var.environment}"
  }

}



# curl http://169.254.169.254/latest/meta-data/ami-id
# ami-0cca134ec43cf708f

# Create EC2 instance 

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.new-key.key_name
  subnet_id              = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_https.id, aws_security_group.allow_ssh.id]

  tags = {
    Name    = "${var.project}-${var.environment}-webserver-instance"
    # project = "${var.project}"
    # env     = "${var.environment}"
  }

}
