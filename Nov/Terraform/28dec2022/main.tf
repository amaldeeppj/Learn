resource "aws_instance" "web" {
  ami                    = "ami-0cca134ec43cf708f"
  instance_type          = "t2.micro"
  key_name               = "devops"
  subnet_id              = "subnet-0a61021da4a89501a"
  vpc_security_group_ids = ["sg-057661ce90b13bf3d"]
  user_data = file("userdata.sh")
  user_data_replace_on_change = true 

  tags = {
    Name    = "${var.project}-${var.environment}-webserver-instance"

  }

}


resource "aws_eip" "this_eip" {
    vpc = true 
    instance = aws_instance.web.id 
    tags = {
      "Name" = "${var.project}-${var.environment}"
    }

}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this_zone.zone_id
  name    = "terraform.${data.aws_route53_zone.this_zone.name}"
  type    = "A"
  ttl     = "1"
  records = [aws_eip.this_eip.public_ip]
}
