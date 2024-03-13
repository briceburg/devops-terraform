
resource "aws_organizations_account" "this" {
  for_each = { for a in local.x_accounts : a.name => a }

  close_on_deletion = true
  email             = "${var.email_user}+aws-${each.key}@${var.email_domain}"
  name              = each.key
  parent_id         = var.ou_tree[each.value.tier].paths["${each.value.ou_path}"]
  role_name         = "OrganizationAccountAccessRole"

  lifecycle {
    ignore_changes = [email, role_name]
  }
}
