variable "regions" {
  type = map(string)
  default = {
    region1 = "ap-south-1"
    region2 = "us-east-1"
  }

  description = "Regions to create AMI"

}

variable "project" {
  type        = string
  default     = "wordpress"
  description = "Project name, to be added in the name tag"

}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Project environment, to be added in the name tag"

}


locals {
  img-time-stamp = "${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  img-name       = "${var.project}-${var.environment}-${local.img-time-stamp}"
}

