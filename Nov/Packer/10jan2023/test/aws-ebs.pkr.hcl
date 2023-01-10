packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "server1" {
  ami_name     = local.img-name
  region       = var.regions.region1
  ssh_username = "ec2-user"
  instance_type = "t2.micro"
  source_ami = var.ami-id[var.regions.region1]
  tags = {
    Name = local.img-name
    project = var.project
    environment = var.environment
  }
}

source "amazon-ebs" "server2" {
  ami_name     = local.img-name
  region       = var.regions.region2
  ssh_username = "ec2-user"
  instance_type = "t2.micro"
  source_ami = var.ami-id[var.regions.region2]
  tags = {
    Name = local.img-name
    project = var.project
    environment = var.environment
  }
}


build {
  sources = [ "source.amazon-ebs.server1", "source.amazon-ebs.server2" ]
  
  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  provisioner "shell" {
    script = "./wordpress.sh"
    execute_command = "sudo {{.Path}}"
  }
}

