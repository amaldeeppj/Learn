variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Region to deploy resources"

}

variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "CIDR for VPC, default CIDR is 172.16.0.0/16"

}

variable "project" {
  type        = string
  default     = "myproject"
  description = "Project name, to be added in the name tag"

}

variable "environment" {
  type        = string
  default     = "dev" 
  description = "Project environment, to be added in the name tag"

}

locals {
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

variable "public_subnet_names" {
    type = list(string)
    default = ["bastion", "web"]
    description = "Name list for public subnets"
  
}

variable "public_subnet_cidr" {
    type = list(string)
    default = ["172.16.0.0/20", "172.16.16.0/20"]
    description = "CIDR list for public subnets"
  
}

variable "public_subnet_azs" {
    type = list(string)
    default = ["ap-south-1a", "ap-south-1a"]
    description = "CIDR list for public subnets"
  
}

variable "private_subnet_names" {
    type = list(string)
    default = ["db"]
    description = "Name list for public subnets"
  
}

variable "private_subnet_cidr" {
    type = list(string)
    default = ["172.16.32.0/20"] 
    description = "CIDR list for public subnets"
  
}

variable "private_subnet_azs" {
    type = list(string)
    default = ["ap-south-1a"]
    description = "CIDR list for public subnets"
  
}