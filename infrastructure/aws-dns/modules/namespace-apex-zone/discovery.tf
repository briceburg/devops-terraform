module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery" # TODO: use relative path
  registrations = {
    "namespace-apex-zone" = {
      name         = aws_route53_zone.namespace_apex.name
      name_servers = aws_route53_zone.namespace_apex.name_servers
      zone_id      = aws_route53_zone.namespace_apex.zone_id

    }
  }
}
