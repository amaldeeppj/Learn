output "url" {
  value = "http://${aws_route53_record.wordpress.fqdn}"
}
