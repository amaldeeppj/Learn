variable "region" {
    type = string
    default = "ap-south-1"
}

variable "project" {
    type = string 
    default = "zomato"
}

variable "environment" {
    type = string
    default = "prod"
}

variable "ingress_ports" {
    type = list(number)
    default = [ 80, 465, 443, 8080, 9090 ]
}

locals {
  common_tags = {
    project = var.project
    environment = var.environment
  }
}
