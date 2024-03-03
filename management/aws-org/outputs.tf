output "accounts" {
  value = { for id, a in module.accounts.accounts : id => a.name }
}

output "groups" {
  value = module.users_and_groups.groups
}

output "identity_store_id" {
  value = local.identity_store_id
}

output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "permissions" {
  value = module.permissions
}

output "users" {
  value = module.users_and_groups.users
}
