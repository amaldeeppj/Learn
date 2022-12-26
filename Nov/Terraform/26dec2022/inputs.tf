variable "region" {
    type = string
    default = "ap-south-1"
    description = "Region to launch resources"
}

variable "project" {
    type = string
    default = "zomato"
    description = "Project"
  
}

variable "environment" {
    type = string
    default = "production"
    description = "Environment"
  
}

variable "instance_ami" {
    type = string
    default = ""
    description = "AMI ID"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "EC2 instance type"
  
}

locals {
  common_tags = {
    project = var.project
    environment = var.environment
  }
}

variable "vpc_cidr" {
    type = string
    default = "172.16.0.0/16"
    description = "VPC CIDR"
}

variable "public_subnet" {
    type = map(string)
    default = {
        "ap-south-1a" = "172.16.0.0/20" 
        "ap-south-1b" = "172.16.16.0/20" 
        "ap-south-1c" = "172.16.32.0/20" 
    }
  
}

variable "private_subnet" {
    type = map(string)
    default = {
        "ap-south-1a" = "172.16.48.0/20" 
        "ap-south-1b" = "172.16.64.0/20" 
        "ap-south-1c" = "172.16.80.0/20" 
    }
  
}


