locals {
  x_accounts = flatten([for tier, ous in var.accounts : [
    for ou, accounts in ous : [
      for account in accounts : {
        name    = lower("${tier}-${account}")
        tier    = tier
        ou_path = lower("${tier}/${ou}")
      }
    ]
  ]])
}
