module "my_vpc" {
    source = "./modules/aws-vpc"

    cidr = var.CIDR
    tags = {
      "Name" = "new_VPC"
      "env" = "testing"
    }
  
}

module "my_subnet" {
    source = "./modules/aws-subnet"

    #Passing vpc id from vpc module  
    vpcID = module.my_vpc.id
    cidr = var.CIDR

  
}

module "my_ec2" {
    source = "./modules/aws-ec2"

    #Passing values from subnet module to create ec2
    subnet = module.my_subnet.subnet_ID 
    tags = {
      Name = "ec2fromTF"
    }

  
}