resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  description      = each.value
  instance_arn     = var.instance_arn
  name             = each.key
  session_duration = var.session_duration
}

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
