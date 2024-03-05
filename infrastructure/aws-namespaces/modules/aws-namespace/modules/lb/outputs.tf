output "arn" {
  value = aws_lb.this.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

output "fqdn" {
  value = aws_route53_record.this.fqdn
}

output "http_listener_arn" {
  value = try(aws_lb_listener.http[0].arn, null)
}

output "https_listener_arn" {
  value = try(aws_lb_listener.https[0].arn, null)
}

output "ssl_policy" {
  value = var.ssl_policy
}

output "type" {
  value = aws_lb.this.load_balancer_type
}

output "zone_id" {
  value = aws_lb.this.zone_id
}
