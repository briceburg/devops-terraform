provider "aws" {
  allowed_account_ids = [var.management_account_id]
  profile             = "iceburg-management/operate"
  region              = var.sso_region

  default_tags {
    tags = {
      Application = "aws-org"
      Org         = var.organization
      Vcs-url     = var.vcs_url
    }
  }
}

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = var.organization_trusted_services

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]

  feature_set = "ALL"
}

module "accounts" {
  source = "./modules/accounts"

  accounts     = var.accounts
  email_domain = var.account_email.domain
  email_user   = var.account_email.user
  organization = var.organization
  root_id      = aws_organizations_organization.this.roots[0].id
}

module "users_and_groups" {
  source = "./modules/users_and_groups"

  groups            = var.groups
  identity_store_id = local.identity_store_id
  users             = var.users
}





