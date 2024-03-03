module "ou_tree" {
  source  = "./modules/ou_tree"
  level_0 = [var.organization]
  level_1 = keys(var.accounts)
  root_id = var.root_id
}

resource "aws_organizations_account" "this" {
  for_each = { for a in local.x_accounts : a.name => a }

  close_on_deletion = true
  email             = "${var.email_user}+aws-${each.value.name}@${var.email_domain}"
  name              = each.value.name
  parent_id         = module.ou_tree.map[each.value.ou_selector].id
  role_name         = "OrganizationAccountAccessRole"

  lifecycle {
    ignore_changes = [email, role_name]
  }
}
