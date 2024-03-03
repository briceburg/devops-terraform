locals {
  x_accounts = flatten([for tier, ous in var.accounts : [
    for ou, accounts in ous : [
      for account in accounts : {
        name        = lower("${tier}-${account}")
        ou_selector = lower("${var.organization}.${tier}.${ou}")
        tier        = lower(tier)
      }
    ]
  ]])
}
