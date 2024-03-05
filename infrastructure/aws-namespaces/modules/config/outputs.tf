output "organization_name" {
  value = var.organization_name
}

output "region" {
  value = var.region
}

output "tags" {
  value = {
    Org     = var.organization_name
    Vcs-url = var.vcs_url
  }
}

output "tier" { # TODO: this should be account_tier, and we should remove the Tier tag from AWS (Stage matters, we can infer Tier from parent OU...)
  value = var.tier
}
