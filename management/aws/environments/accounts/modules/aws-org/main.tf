
resource "aws_organizations_organizational_unit" "this" {
  name      = var.organization_name
  parent_id = var.root_id
}

module "ou_tree" {
  source   = "./modules/ou_tree"
  for_each = var.accounts

  level_0   = [each.key]       # tier
  level_1   = keys(each.value) # ous
  parent_id = aws_organizations_organizational_unit.this.id
}

module "accounts" {
  source = "./modules/accounts"

  accounts     = var.accounts
  email_domain = var.account_email.domain
  email_user   = var.account_email.user
  ou_tree      = module.ou_tree
}
