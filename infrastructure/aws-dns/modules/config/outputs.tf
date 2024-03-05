output "apex_zone_root_domain" {
  value = var.apex_zone_root_domain
}

output "organization_name" {
  value = var.organization_name
}

output "region" {
  value = var.region
}

output "tags" {
  value = {
    Application = "aws-dns"
    Org         = var.organization_name
    Tier        = var.tier
    Vcs-url     = var.vcs_url
  }
}

output "tier" {
  value = var.tier
}
