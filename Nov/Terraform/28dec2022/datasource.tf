data "aws_route53_zone" "this_zone" {
    name = var.domain 
    
}