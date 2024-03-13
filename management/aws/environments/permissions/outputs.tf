output "permission_sets" {
  value = keys(module.permission_sets.permission_sets)
}

output "service_control_policies" {
  value = module.scp
}

output "assignments" {
  value = module.permission_set_assignments
}

