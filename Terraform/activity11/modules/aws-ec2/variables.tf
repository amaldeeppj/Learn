variable "tags" {
    description = "tags of ec2"
    type = map(string)
    default = {}
  
}

variable "subnet" {
    description = "subnet id"
    type = string
    
  
}