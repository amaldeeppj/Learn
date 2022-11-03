resource "aws_subnet" "subnets" {
    count = 6

    vpc_id = aws_vpc.amaldeep_vnetpc.id
    cidr_block = "10.0.${count.index}.0/24"

    tags = {
      "Name" = "subnet_tf_${count.index}"
    }
  
}
