output "this_zone_id" {
    description = "zone ID"
    value = data.aws_route53_zone.this_zone.id 
}


output "this_url" {
    value = "http://terraform.amaldeep.tech"
  
}

