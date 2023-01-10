resource "aws_instance" "wordpress" {
    ami = data.aws_ami.latest.id 
    instance_type = "t2.micro"
    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
  
}

# ap-south-1: ami-0442e30705f684682
# ap-south-1: ami-0227ac48b5407ec77


# ami-02398a9c949c5844f
# ami-0917b6c8eccbab64e