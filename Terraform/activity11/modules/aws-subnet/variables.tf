variable "tags" {
    description = "tags for subnet"
    type = map(string)
    default = {}

  
}

variable "cidr" {
    description = "cidr block for subnet"
    type = string
    default = "10.0.0.0/16"
  
}

variable "vpcID" {
    description = "VPC ID"
    type = string
  
}