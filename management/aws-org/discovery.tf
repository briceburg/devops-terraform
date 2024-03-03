#  allows organization data such as accounts to be discovered,
#  via terraform remote state, outputs, or S3 URLs.

module "discovery" {
  source = "./modules/discovery"

  organization_id = aws_organizations_organization.this.id
  accounts        = module.accounts.accounts
  ou_paths        = { for k, v in module.accounts.ou_tree : k => v.path }
}
