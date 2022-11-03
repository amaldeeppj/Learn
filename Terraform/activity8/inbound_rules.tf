resource "aws_security_group_rule" "inbound" {
    count = length(var.port)
    type = "ingress"
    security_group_id = aws_security_group.sec_group.id
    from_port = var.port[count.index]
    to_port = var.port[count.index]
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
}
