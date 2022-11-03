variable devregion{
    type = string
    default = "us-east-1"
}

variable ip_range{
    type = string
    default = "10.0.0.0/16"
}

variable "environment" {
    type = string
    default = "TF_test"
  
}

variable "instance" {
    type = list(string)
    default = [ "web", "db", "cache", "auth" ]
}
