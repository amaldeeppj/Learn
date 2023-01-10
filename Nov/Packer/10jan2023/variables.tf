variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Region to deploy resources"

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

