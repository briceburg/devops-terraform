output "permission_sets" {
  value = { for k, v in aws_ssoadmin_permission_set.this : k => v.id }
}
