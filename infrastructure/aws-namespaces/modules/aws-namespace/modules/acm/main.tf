resource "aws_acm_certificate" "this" {
  domain_name       = var.route53.fqdn
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${var.route53.fqdn}",
    "*.${var.route53.service_discovery_zone}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

resource "aws_route53_record" "acm-validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.acm-validation : record.fqdn]
}
