variable "region" {
    type = string
    default = "ap-south-1"
    description = "Region to deploy resources"
  
}

variable "project" {
    type = string
    default = "zomato"
    description = "Project name, to be added in the name tag"
  
}

variable "environment" {
    type = string 
    default = "prod"
    description = "Project environment, to be added in the name tag"
  
}


variable "domain" {
    type = string 
    default = "amaldeep.tech"
  
}

locals {
  common_tags = {
    project = var.project 
    environment = var.environment 
  }
}

