resource "aws_vpc" "tf_vpc" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "vpc from tf"
  }
}
