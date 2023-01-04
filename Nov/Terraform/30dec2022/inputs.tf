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
  default     = "prod"
  description = "Project environment, to be added in the name tag"

}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Should be true to enable nat gateway, There will be only one nat gateway, which will be shared by all private subnets"
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



# locals {

#   instances = {
#     bastion = {
#       subnet          = aws_subnet.this_public[0].id
#       security_groups = [aws_security_group.bastion_sg.id]
#       userdata        = false
#       userdata_file   = "test.sh"
#       depends         = null
#     }

#     dbserver = {
#       subnet          = aws_subnet.this_private[0].id
#       security_groups = [aws_security_group.internalssh_sg.id, aws_security_group.dbserver_sg.id]
#       userdata        = true
#       userdata_file   = "test.sh"
#       depends         = null
#     }
#   }

# }

# locals {
#   webserver = {
#     subnet          = aws_subnet.this_public[1].id
#     security_groups = [aws_security_group.internalssh_sg.id, aws_security_group.webserver_sg.id]
#     userdata        = true
#     userdata_file   = "test"
#     depends         = aws_instance.this_ec2[*] 
#   }

# }


locals {
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

locals {
  azs = length(data.aws_availability_zones.available.names)
}



# locals {
#   ip = <<EOF
#     #!/bin/bash
#     DB_host=${aws_instance.this_ec2["webserver"].private_ip}
#     echo $DB_HOST > /usr/local/src/private_ip
#     EOF

# }



