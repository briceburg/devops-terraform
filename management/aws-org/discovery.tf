#  allows organization data such as accounts to be discovered,
#  via terraform remote state, outputs, or S3 URLs.

module "discovery" {
  source = "./modules/discovery"

  organization_id = aws_organizations_organization.this.id
  accounts        = { for a in local.x_accounts : module.account[a.name].id => a }
  ou_paths        = { for k, v in module.ou_tree.map : k => v.path }
}
