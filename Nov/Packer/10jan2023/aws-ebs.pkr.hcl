# https://developer.hashicorp.com/terraform/tutorials/provision/packer

packer {
  required_plugins {
    amazon = {
      # https://developer.hashicorp.com/packer/plugins/builders/amazon
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
  source_ami_filter {
    filters = {
      root-device-type    = "ebs"
      architecture        = "x86_64"
      virtualization-type = "hvm"

    }
    most_recent = true
    owners = ["amazon"]
  }
  tags = {
    Name = local.img-name
    project = var.project
    environment = var.environment
  }
  skip_create_ami = false
}

source "amazon-ebs" "server2" {
  ami_name     = local.img-name
  region       = var.regions.region2
  ssh_username = "ec2-user"
  instance_type = "t2.micro"
  # https://developer.hashicorp.com/packer/tutorials/aws-get-started/aws-get-started-build-image
  source_ami_filter {
    # https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
    # add filter for name ##########################################
    filters = {
      root-device-type    = "ebs"
      architecture        = "x86_64"
      virtualization-type = "hvm"

    }
    most_recent = true
    owners = ["amazon"]
  }
  tags = {
    Name = local.img-name
    project = var.project
    environment = var.environment
  }
  
  # https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs
  skip_create_ami = false
}

build {
  sources = [ "source.amazon-ebs.server1", "source.amazon-ebs.server2" ]
  
  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  provisioner "shell" {
    script = "./wordpress.sh"
    execute_command = "sudo {{.Path}}"
  }
}

