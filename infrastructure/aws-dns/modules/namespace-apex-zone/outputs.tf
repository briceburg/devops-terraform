output "name" {
  value = aws_route53_zone.namespace_apex.name
}

output "name_servers" {
  value = aws_route53_zone.namespace_apex.name_servers
}
