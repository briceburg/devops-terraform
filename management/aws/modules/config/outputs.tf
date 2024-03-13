output "management_account_id" {
  value = var.management_account_id
}

output "management_aws_profile" {
  value = var.management_aws_profile
}

output "sso_region" {
  value = var.sso_region
}

output "sso_start_url" {
  value = var.sso_start_url
}

output "tags" {
  value = {
    Application = "aws-management"
    Vcs-url     = var.vcs_url
  }
}
