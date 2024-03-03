resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  description      = each.value
  instance_arn     = var.instance_arn
  name             = each.key
  session_duration = var.session_duration
}

resource "aws_ssoadmin_account_assignment" "management" {
  for_each = toset(var.management_groups)

  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[var.management_permission_set].arn

  principal_id   = var.groups[each.value]
  principal_type = "GROUP"

  target_id   = var.management_account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "x_permissions" {
  for_each = local.x_permissions

  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value[0].permission_set].arn

  principal_id   = var.groups[each.value[0].group]
  principal_type = "GROUP"

  target_id   = [for account_id, account in var.accounts : account_id if account.name == each.value[0].account][0]
  target_type = "AWS_ACCOUNT"
}

#
# policy attachments
#


