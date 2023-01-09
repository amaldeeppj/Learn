module "vpc" {
    source = "github.com/amaldeeppj/VPC-Terraform.git"

    common_name_tag = "${var.project}-${var.environment}"
    common_tags = local.common_tags
    vpc_cidr = var.vpc_cidr
    public_subnet_names = var.public_subnet_names
    public_subnet_cidr = var.public_subnet_cidr 
    public_subnet_azs = var.public_subnet_azs 
    private_subnet_names = var.private_subnet_names 
    private_subnet_cidr = var.private_subnet_cidr  
    private_subnet_azs = var.private_subnet_azs 
}
