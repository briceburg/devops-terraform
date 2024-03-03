output "discovery" {
  value = module.discovery
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

output "users" {
  value = module.users_and_groups.users
}
