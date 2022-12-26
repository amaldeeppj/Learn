resource "aws_vpc" "this_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true 

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
}

resource "aws_internet_gateway" "this_igw" {
    vpc_id = aws_vpc.this_vpc.id

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
  
}

# Private and public subnet creation in a single loop

# resource "aws_subnet" "this_subnet" {
#     count = 6
#     vpc_id = aws_vpc.this_vpc.id
#     cidr_block = cidrsubnet(var.vpc_cidr, 4, "${count.index}")
#     map_public_ip_on_launch = "${count.index < 3 ? true : false}" 
#     availability_zone = data.aws_availability_zones.available.names["${count.index%3}"]

#     tags = {
#       "Name" = "${var.project}-${var.environment}-${count.index < 3 ? "public" : "private"}-subnet-${count.index%3+1}"
#     }
  
# }

resource "aws_subnet" "this_public_subnet" {
    
    for_each = var.public_subnet 
        vpc_id = aws_vpc.this_vpc.id
        cidr_block = each.value
        availability_zone = each.key
        map_public_ip_on_launch = true 
        
        tags = {
          "Name" = "${var.project}-${var.environment}-public-${each.key}"
        }
  
}


resource "aws_subnet" "this_private_subnet" {
    for_each = var.private_subnet
        vpc_id = aws_vpc.this_vpc.id 
        cidr_block = each.value
        availability_zone = each.key
        map_public_ip_on_launch = false 

        tags = {
          "Name" = "${var.project}-${var.environment}-private-${each.key}"
        }
  
}



# EIP may require IGW to exist prior to association. Use depends_on to set an explicit dependency on the IGW.
# Do not use network_interface to associate the EIP to aws_lb or aws_nat_gateway resources. 
# Instead use the allocation_id available in those resources to allow AWS to manage the association, 
# otherwise you will see AuthFailure errors.

resource "aws_eip" "this_eip" {
    vpc = true 
    depends_on = [
      aws_internet_gateway.this_igw
    ]
  
    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
}


# NAT GateWay in public subnet 2 

resource "aws_nat_gateway" "this_nat_gw" {
    allocation_id = aws_eip.this_eip.id 
    subnet_id = aws_subnet.this_public_subnet["${keys(var.public_subnet)[1]}"].id 

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
  
}


# NOTE on gateway_id and nat_gateway_id:
# The AWS API is very forgiving with these two attributes 
# and the aws_route_table resource can be created with a NAT ID specified as a Gateway ID attribute. 
# This will lead to a permanent diff between your configuration and statefile, 
# as the API returns the correct parameters in the returned route table. 
# If you're experiencing constant diffs in your aws_route_table resources, 
# the first thing to check is whether or not you're specifying a NAT ID instead of a Gateway ID, or vice-versa.

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
    vpc_id = aws_vpc.this_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.this_nat_gw.id 
    }  

    tags = {
      "Name" = "${var.project}-${var.environment}-private"
    }
}

resource "aws_route_table_association" "this_public" {
    count = "${length(var.public_subnet)}"
    subnet_id = aws_subnet.this_public_subnet["${keys(var.public_subnet)[count.index]}"].id
    route_table_id = aws_route_table.this_public_route.id
}


resource "aws_route_table_association" "this_private" {
    count = "${length(var.private_subnet)}"
    subnet_id = aws_subnet.this_public_subnet["${keys(var.private_subnet)[count.index]}"].id
    route_table_id = aws_route_table.this_private_route.id 
}

