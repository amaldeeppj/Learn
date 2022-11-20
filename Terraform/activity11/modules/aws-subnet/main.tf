resource "aws_subnet" "this_subnet" {
    vpc_id = var.vpcID
    cidr_block = cidrsubnet(var.cidr, 8, 1)
    tags = var.tags 

}
