output "region" {
  value = var.network_region
}

output "tags" {
  value = {
    Application = "aws-network"
    Org         = var.organization_name
    Tier        = var.tier
    Vcs-url     = var.vcs_url
  }
}

output "tier" {
  value = var.tier
}
