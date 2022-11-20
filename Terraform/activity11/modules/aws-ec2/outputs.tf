output "ec2_arn" {
    description = "ARN of EC2"
    value = aws_instance.web.arn
  
}

output "public_IP" {
    description = "ec2 public IP"
    value = aws_instance.web.public_ip
  
}