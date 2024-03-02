output "account_id" {
  value = var.account_map[var.tier]
}

output "region" {
  value = var.state_region
}

output "tags" {
  value = {
    Application = "tfstate"
    Org         = var.organization
    Tier        = var.tier
    Vcs-url     = var.vcs_url
  }
}
