output "public_ip" {
  value = aws_instance.web.public_ip

}

output "public_dns" {
  value = aws_instance.web.public_dns

}

output "ssh-link" {
  value = "ssh -i mykey ec2-user@${aws_instance.web.public_ip}"

}

output "ec2-id" {
  value = aws_instance.web.id

}

output "ec2-arn" {
  value = aws_instance.web.arn

}

