resource "aws_organizations_account" "this" {
  close_on_deletion = true
  email             = var.email
  name              = var.name
  parent_id         = var.parent_id
  role_name         = "OrganizationAccountAccessRole"

  lifecycle {
    ignore_changes = [email, role_name]
  }
}
