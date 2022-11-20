variable "cidr" {
    description = "CIDR of the desired VPC"
    type = string
    default = "10.0.0.0/16"
  
}

variable "tags" {
    description = "Tags of VPC"
    type = map(string)
    default = {}

}