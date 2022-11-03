resource "aws_subnet" "subnet_tf" {
  count = length(var.instance)
  vpc_id            = aws_vpc.new_vpc_tf.id
  cidr_block        = cidrsubnet(aws_vpc.new_vpc_tf.cidr_block, 8, count.index)
  #availability_zone = var.devregion

  tags = {
    Name = "tf-subnet_${var.instance[count.index]}"
  }
}

