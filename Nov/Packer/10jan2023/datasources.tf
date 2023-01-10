data "aws_ami" "latest" {
    owners = ["self"]
    most_recent = true 
    filter {
      name = "tag:Name"
      values = ["${var.project}-${var.environment}-*"]
    }

    filter {
      name = "tag:project"
      values = ["${var.project}"]
    }

    filter {
      name = "tag:environment"
      values = ["${var.environment}"]
    }

filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}