output "availability_zones_count" {
    description = "Number of availability zones in specified region"
    value = length(data.aws_availability_zones.available.names)
}

output "vpc_id" {
    description = "VPC id"
    value = aws_vpc.this_vpc.id 
}

