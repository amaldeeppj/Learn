resource "aws_vpc" "this_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
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
    count = local.azs
    vpc_id = aws_vpc.this_vpc.id 
    map_public_ip_on_launch = true 
    cidr_block = cidrsubnet(var.vpc_cidr, 4, "${count.index}")
    availability_zone = data.aws_availability_zones.available.names["${count.index}"]

    tags = {
        Name = "${var.project}-${var.environment}-public-${substr(data.aws_availability_zones.available.names["${count.index}"],-2, 2)}"
    }
}

resource "aws_subnet" "this_private" {
    count = local.azs
    vpc_id = aws_vpc.this_vpc.id 
    map_public_ip_on_launch = false 
    cidr_block = cidrsubnet(var.vpc_cidr, 4, "${sum([count.index, local.azs])}")
    availability_zone = data.aws_availability_zones.available.names["${count.index}"]

    tags = {
        Name = "${var.project}-${var.environment}-private-${substr(data.aws_availability_zones.available.names["${count.index}"],-2, 2)}"
    }
  
}


resource "aws_eip" "this_eip" {
    count = var.enable_nat_gateway ? 1 : 0
    vpc = true 
    
    depends_on = [
      aws_internet_gateway.this_igw
    ]

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }

}

resource "aws_nat_gateway" "this_nat" {
    count = var.enable_nat_gateway ? 1 : 0
    allocation_id = aws_eip.this_eip[0].id 
    subnet_id = aws_subnet.this_public[1].id 

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
    count = var.enable_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.this_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.this_nat[0].id 
    }  

    tags = {
      "Name" = "${var.project}-${var.environment}-private"
    }
}

resource "aws_route_table_association" "this_public" {
    count = local.azs
    subnet_id = aws_subnet.this_public["${count.index}"].id
    route_table_id = aws_route_table.this_public_route.id
}


resource "aws_route_table_association" "this_private" {
    count = var.enable_nat_gateway ? local.azs : 0
    subnet_id = aws_subnet.this_private["${count.index}"].id
    route_table_id = aws_route_table.this_private_route[0].id 
}