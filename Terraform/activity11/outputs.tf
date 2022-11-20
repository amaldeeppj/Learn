output "ARN" {
    description = "ARN of VPC"
    value = module.my_vpc.arn
  
}

output "ID" {
    description = "ID of VPC"
    value = module.my_vpc.id
  
}

output "SG" {
    description = "owner ID"
    value = module.my_vpc.sg
  
}