output "management_account_id" {
  value = var.management_account_id
}

output "organization_name" {
  value = var.organization_name
}

output "region" {
  value = var.state_region
}

output "shared_services_account_id_map" {
  value = var.shared_services_account_id_map
}

output "tags" {
  value = {
    Application = "tfstate"
    Org         = var.organization_name
    Vcs-url     = var.vcs_url
  }
}
