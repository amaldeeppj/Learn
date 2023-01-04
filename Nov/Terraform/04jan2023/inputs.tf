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
  default     = "zomato"
  description = "Project name, to be added in the name tag"

}

variable "environment" {
  type        = string
  default     = "test" # test or stage
  description = "Project environment, to be added in the name tag"

}


variable "ami" {
  type        = string
  default     = "ami-0cca134ec43cf708f"
  description = "AMI ID"

}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"

}


variable "ssh_key" {
  type        = string
  default     = "devops"
  description = "Existing key"

}

variable "test_ssh_key" {
  type        = string
  default     = "devops"
  description = "Existing key"

}

variable "stage_ssh_key" {
  type        = string
  default     = "devops"
  description = "Existing key"

}

variable "webserver_ports" {
  type        = list(any)
  default     = [80, 443, 8080]
  description = "Ports to open in Webserver"
}

locals {
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

variable "db_name" {
  type        = string
  default     = "wpdb"
  description = "DB name"
}

variable "db_user" {
  type        = string
  default     = "wpuser"
  description = "DB user name"
}

variable "db_password" {
  type        = string
  default     = "admin@123"
  description = "DB password"
}

variable "db_root_password" {
  type        = string
  default     = "admin@1234"
  description = "DB root password"
}

variable "private_zone" {
  type        = string
  default     = "private.amaldeep.tech"
  description = "private zone to host db server"

}

