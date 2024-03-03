output "permission_sets" {
  value = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}

output "service_control_policies" {
  value = { for k, v in aws_organizations_policy.scp : k => v.arn }
}
