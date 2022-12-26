variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "value"

}

variable "project" {
  type        = string
  default     = "zomato"
  description = "project name"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "project env"

}

variable "access-key" {
  type        = string
  default     = "/home/amaldeep/mykey.pub"
  description = "key path"
}


variable "cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "ami" {
  type    = string
  default = "ami-0cca134ec43cf708f"

}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}

variable "az" {
  type    = string
  default = "ap-south-1a"

}

variable "owner" {
  type = string
  default = "amaldeep"
  
}

variable "application" {
  type = string
  default = "food-order"
  
}

# Variables cannot be mentioned in another variable 

# variable common_tags {
#   type = map 
#   default = {
#     "project" = var.project
#     "env"     = var.environment
#   }
# }

# Declaring local value  

locals {
  common_tags = {
    project = var.project
    env = var.environment 
    owner = var.owner
    application = var.application
  }
}


