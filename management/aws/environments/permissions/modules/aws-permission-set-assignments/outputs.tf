output "assignments" {
  value = concat(
    [for group in var.management_groups : "management/${group}/${var.management_permission_set}"],
    keys(aws_ssoadmin_account_assignment.x)
  )
}
