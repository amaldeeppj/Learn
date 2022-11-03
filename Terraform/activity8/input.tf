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

variable "service" {
    type = list(string)
    default = [ "SSH", "HTTP", "HTTPS", "FTP", "DB_connection" ]
}

variable "port" {
    type = list(number)
    default = [ 22, 80, 443, 21, 3306 ]

  
}


variable "ami" {
    type = string
    default = "ami-081dc0707789c2daf"
  
}

variable "instanceType" {
    type = string
    default = "t2.micro"
  
}

