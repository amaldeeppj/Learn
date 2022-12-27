# Simple VPC 

* Creates a VPC in specified region with specified CIDR, creates private and public subnets in all availability zones. 
* Optional NAT Gateway. There will be only one NAT Gateway, and it will be shared by all private subnets
* Can be used for development environment


## Requirements

Name | Version
--- | ---
Terraform | >= v1.3.6
AWS | >= v4.48.0
 


## Inputs 

Value | Description | Optional
--- | --- | ---
region | Region to deploy resources | No
vpc_cidr | CIDR for VPC, default CIDR is 172.16.0.0/16 | Yes
project | Project name, to be added in the name tag | No 
environment | Project environment, to be added in the name tag | No 
enable_nat_gateway | Should be `true` to enable nat gateway | Yes


## Outputs 

Value | Description
--- | --- 
available_zones_count | Number of availability zones in specified region
vpc_id | VPC id
