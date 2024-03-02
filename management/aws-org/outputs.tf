output "discovery" {
  value = module.discovery
}

output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "ou_tree" {
  value = module.ou_tree
}



