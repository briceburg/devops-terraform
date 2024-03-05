output "fqdn" {
  value = aws_route53_zone.this.name
}

output "service_discovery_zone" {
  value = aws_service_discovery_private_dns_namespace.this.name
}

output "service_discovery_zone_id" {
  value = aws_service_discovery_private_dns_namespace.this.id
}

output "zone_id" {
  value = aws_route53_zone.this.zone_id
}


