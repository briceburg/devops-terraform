output "accounts" {
  # account keys are well-known at plan time to satisfy fresh for_each requirements
  value = { for a in local.x_accounts : a.name => {
    id      = aws_organizations_account.this[a.name].id
    ou_path = a.ou_path
  } }
}
