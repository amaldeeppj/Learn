resource "aws_vpc" "new_vpc_tf" {
  cidr_block = var.ip_range

  tags = {
    Name = "tf-vpc_${var.environment}"
  }
}


