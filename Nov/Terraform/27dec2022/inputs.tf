variable "region" {
    type = string
    description = "Region to deploy resources"
  
}

variable "vpc_cidr" {
    type = string
    default = "172.16.0.0/16"
    description = "CIDR for VPC, default CIDR is 172.16.0.0/16"
  
}

variable "project" {
    type = string
    description = "Project name, to be added in the name tag"
  
}

variable "environment" {
    type = string 
    description = "Project environment, to be added in the name tag"
  
}

variable "enable_nat_gateway" {
    type = bool 
    default = false
    description = "Should be true to enable nat gateway, There will be only one nat gateway, which will be shared by all private subnets"
}


locals {
  common_tags = {
    project = var.project 
    environment = var.environment 
  }
}



