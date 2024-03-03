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

  target_id   = [for account_id, account in var.accounts.accounts : account_id if account.name == each.value[0].account][0]
  target_type = "AWS_ACCOUNT"
}

#
# policy attachments
#

resource "aws_ssoadmin_managed_policy_attachment" "x_managed_policies" {
  for_each           = { for p in local.x_managed_policies : p.key => p }
  instance_arn       = var.instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "x_inline_policies" {
  for_each = local.x_inline_policies

  instance_arn       = var.instance_arn
  inline_policy      = each.value
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

#
# service control policies (SCPs)
#

resource "aws_organizations_policy" "scp" {
  for_each = local.service_control_policies
  name     = each.key
  content  = each.value.content
  type     = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "scp" {
  for_each  = { for x in local.x_scp_attachments : x.key => x }
  policy_id = aws_organizations_policy.scp[each.value.scp_name].id
  target_id = var.accounts.ou_tree[each.value.ou_selector].id
}

