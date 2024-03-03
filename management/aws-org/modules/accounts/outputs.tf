output "accounts" {
  value = { for a in local.x_accounts : aws_organizations_account.this[a.name].id => a }
}

output "ou_tree" {
  value = module.ou_tree.map
}
