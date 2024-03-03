output "discovery" {
  value = module.discovery
}

output "identity_store_id" {
  value = local.identity_store_id
}

output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "ou_tree" {
  value = module.ou_tree
}



