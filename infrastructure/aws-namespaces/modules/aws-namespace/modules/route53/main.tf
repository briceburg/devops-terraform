resource "aws_route53_zone" "this" {
  name          = "${var.namespace_id}.${local.apex_zone.name}"
  comment       = "zone for the ${var.namespace_id} namespace"
  force_destroy = true

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "internal.${aws_route53_zone.this.name}"
  description = "service discovery zone for the ${var.namespace_id} namespace"
  vpc         = data.aws_vpc.default.id

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

# needed for shared networks (e.g. when namespace does not get its own VPC)
resource "aws_route53_vpc_association_authorization" "shared" {
  vpc_id  = var.vpc_id
  zone_id = aws_service_discovery_private_dns_namespace.this.hosted_zone
}

resource "aws_route53_zone_association" "shared" {
  provider = aws.ram

  vpc_id  = aws_route53_vpc_association_authorization.shared.vpc_id
  zone_id = aws_route53_vpc_association_authorization.shared.zone_id
}

#
# register namespace zone with apex
#

resource "aws_route53_record" "apex-delegation" {
  provider = aws.dns

  zone_id = local.apex_zone.zone_id
  name    = aws_route53_zone.this.name

  type    = "NS"
  records = aws_route53_zone.this.name_servers
  ttl     = 300

  allow_overwrite = true
}
