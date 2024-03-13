resource "aws_ssoadmin_account_assignment" "management" {
  for_each = toset(var.management_groups)

  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_sets[var.management_permission_set].arn

  principal_id   = var.org_data.groups[each.key]
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.management.account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "x" {
  for_each = local.x_permissions

  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_sets[each.value[0].permission_set].arn

  principal_id   = var.org_data.groups[each.value[0].group]
  principal_type = "GROUP"

  target_id   = [for account_id, account in var.org_data.accounts : account_id if account.name == each.value[0].account][0]
  target_type = "AWS_ACCOUNT"
}
