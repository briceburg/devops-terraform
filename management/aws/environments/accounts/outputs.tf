output "accounts" {
  value = local.accounts
}

output "discovery" {
  value = module.discovery_bucket
}

output "ou_paths" {
  value = local.ou_paths
}
