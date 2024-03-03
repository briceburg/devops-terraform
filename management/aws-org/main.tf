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

#
# OUs and accounts
#

module "ou_tree" {
  source  = "./modules/ou_tree"
  level_0 = [var.organization]
  level_1 = keys(var.accounts)
  root_id = aws_organizations_organization.this.roots[0].id
}

module "account" {
  for_each = { for a in local.x_accounts : a.name => a }

  source    = "./modules/account"
  name      = each.value.name
  email     = "${var.account_email.user}+aws-${each.value.name}@${var.account_email.domain}"
  parent_id = module.ou_tree.map[each.value.ou_selector].id
}

#
# users and group assignments
#

resource "aws_identitystore_user" "main" {
  for_each = var.users

  display_name      = each.value.name
  identity_store_id = local.identity_store_id
  user_name         = each.key

  name {
    given_name  = regex("^(?P<fname>\\S*)\\s(?P<lname>.*)$", each.value.name)["fname"]
    family_name = regex("^(?P<fname>\\S*)\\s(?P<lname>.*)$", each.value.name)["lname"]
  }

  emails {
    value = each.key
  }
}

module "group" {
  for_each          = var.groups
  source            = "./modules/group"
  name              = each.key
  description       = each.value
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group_membership" "main" {
  for_each = { for v in local.x_group_assignments : v.key => v }

  identity_store_id = local.identity_store_id
  group_id          = module.group[each.value.group].id
  member_id         = aws_identitystore_user.main[each.value.email].user_id
}




