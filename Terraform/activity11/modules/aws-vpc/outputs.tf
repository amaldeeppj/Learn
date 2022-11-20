output "arn" {
  description = "Amazon Resource Name(ARN) of VPC"
  value = aws_vpc.vpc.arn
}

output "id" {
    description = "ID of the VPC"
    value = aws_vpc.vpc.id
  
}

output "sg" {
    description = "security group"
    value = aws_vpc.vpc.default_security_group_id
  
}

