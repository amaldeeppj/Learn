variable "region" {
  type    = string
  default = "ap-south-1"

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
