output "email" {
  value = var.email
}

output "management_account_id" {
  value = var.management_account_id
}

output "organization" {
  value = var.organization
}

output "organization_trusted_services" {
  value = var.organization_trusted_services
}

output "sso_region" {
  value = var.sso_region
}

output "tags" {
  value = {
    Application = "aws-org"
    Org         = var.organization
    Vcs-url     = var.vcs_url
  }
}
