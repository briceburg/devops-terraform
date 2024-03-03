locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  x_accounts = flatten([for tier, ous in var.accounts : [
    for ou, accounts in ous : [
      for account in accounts : {
        name        = lower("${tier}-${account}")
        ou_selector = lower("${var.organization}.${tier}.${ou}")
        tier        = lower(tier)
      }
    ]
  ]])

  x_group_assignments = flatten([for email, u in var.users : [
    for group in u.groups : {
      email = email
      group = group
      key   = lower("${group}_${email}")
    }
  ]])
}
