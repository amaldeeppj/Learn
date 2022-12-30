resource "aws_security_group" "this_sg" {
    name_prefix = "${var.project}-${var.environment}"
    description = "Allow webserver access"
    vpc_id = data.aws_vpc.this_vpc.id 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
        ipv6_cidr_blocks = ["::/0"]

    }

    lifecycle {
      create_before_destroy = true 
    }

    tags = {
        Name = "${var.project}-${var.environment}"
    }
}

resource "aws_security_group_rule" "this_sg_rule" {
    count = length(var.ingress_ports)
    security_group_id = aws_security_group.this_sg.id
    type = "ingress"
    from_port = var.ingress_ports[count.index]
    to_port = var.ingress_ports[count.index]
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    description = "open incoming port ${var.ingress_ports[count.index]}"
}
