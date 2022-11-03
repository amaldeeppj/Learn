resource "aws_security_group" "sec_group" {
#   count = length(var.service)
  name        = "sec_grp_TF"
  description = "configure ports"
  vpc_id      = aws_vpc.new_vpc_tf.id

#   ingress {
#     description      = "incoming port for ${var.service[count.index]}"
#     from_port        = var.port[count.index]
#     to_port          = var.port[count.index]
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf-secGrp_${var.environment}"
  }
}
