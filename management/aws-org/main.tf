module "config" {
  source = "./modules/config"
}

provider "aws" {
  allowed_account_ids = [module.config.management_account_id]
  profile             = "iceburg-management/operate"
  region              = module.config.sso_region

  default_tags {
    tags = module.config.tags
  }
}

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = module.config.organization_trusted_services

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]

  feature_set = "ALL"
}

#
# ou tree and accounts
#

module "ou_tree" {
  source  = "./modules/ou_tree"
  level_0 = [module.config.organization]
  level_1 = keys(local.account_map)
  root_id = aws_organizations_organization.this.roots[0].id
}

module "account" {
  for_each = { for a in local.x_accounts : a.name => a }

  source    = "./modules/account"
  name      = each.value.name
  email     = "${module.config.email.user}+aws-${each.value.name}@${module.config.email.domain}"
  parent_id = module.ou_tree.map[each.value.ou_selector].id
}

