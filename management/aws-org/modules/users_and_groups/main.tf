resource "aws_identitystore_user" "this" {
  for_each = var.users

  display_name      = each.value.name
  identity_store_id = var.identity_store_id
  user_name         = each.key

  name {
    given_name  = regex("^(?P<fname>\\S*)\\s(?P<lname>.*)$", each.value.name)["fname"]
    family_name = regex("^(?P<fname>\\S*)\\s(?P<lname>.*)$", each.value.name)["lname"]
  }

  emails {
    value = each.key
  }
}

resource "aws_identitystore_group" "this" {
  for_each = var.groups

  display_name      = each.key
  description       = each.value
  identity_store_id = var.identity_store_id
}

resource "aws_identitystore_group_membership" "this" {
  for_each = { for v in local.x_group_assignments : v.key => v }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.this[each.value.group].group_id
  member_id         = aws_identitystore_user.this[each.value.email].user_id
}

