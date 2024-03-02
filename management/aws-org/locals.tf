locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  x_accounts = flatten([for tier, ous in local.account_map : [
    for ou, accounts in ous : [
      for account in accounts : {
        name        = lower("${tier}-${account}")
        ou_selector = lower("${module.config.organization}.${tier}.${ou}")
        tier        = lower(tier)
      }
    ]
  ]])
}


# locals {
#   companies         = keys(local.company_accounts)
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
#   instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   tags              = { for k, v in data.aws_default_tags.this.tags : lower(k) => v }
#   tiers             = ["production", "staging", "development"]
#   x_accounts = concat(
#     flatten([for company, c in local.company_accounts : [
#       for account in c.accounts : [
#         for tier in try(account.tiers, local.tiers) : {
#           name        = lower("${company}-${account.id}-${tier}")
#           ou_selector = lower("${company}.${tier}.${try(account.ou, "Workloads")}")
#           tier        = tier
#         }
#       ]
#     ]]),
#     flatten([for company, c in local.company_accounts : [
#       for account in c.sandboxes : {
#         name        = lower("${company}-${account}-sandbox")
#         ou_selector = lower("${company}.development.Workloads")
#         tier        = "development"
#       }
#     ]])
#   )
#   x_account_permissions = flatten([for selector, perms in local.account_permissions : [
#     for account in local.x_accounts : [
#       for x in perms : [
#         for p in setproduct(x.groups, x.permission_sets) : {
#           account        = account.name
#           group          = p[0]
#           permission_set = p[1]
#         }
#       ]
#     ] if selector == "." || startswith(lower(account.ou_selector), lower(selector))
#   ]])

#   x_group_permissions = flatten([for group, perms in local.group_permissions : [
#     for x in perms : [
#       for p in setproduct(x.accounts, x.permission_sets) : {
#         account        = p[0]
#         group          = group
#         permission_set = p[1]
#       }
#     ]
#     ]
#   ])

#   x_permissions = merge(
#     { for p in local.x_account_permissions : lower("${p.account}-${p.group}-${p.permission_set}") => p... },
#     { for p in local.x_group_permissions : lower("${p.account}-${p.group}-${p.permission_set}") => p... },
#   )

#   x_managed_policies = flatten([
#     for perm, arns in local.managed_policies : [
#       for arn in arns : {
#         key  = "${perm}_${regex(".*/(.*)$", arn)[0]}"
#         perm = perm
#         arn  = arn
#       }
#     ]
#   ])

#   x_scp_attachments = flatten([
#     for scp, v in local.x_scps : [
#       for selector in v.ou_selectors : {
#         key         = "${scp}_${selector}"
#         scp         = scp
#         ou_selector = selector
#       }
#     ]
#   ])

#   x_users = flatten([for email, groups in local.user_groups_map : [
#     for group in groups : {
#       email = email
#       group = group
#       key   = lower("${group}_${email}")
#     }
#   ]])

# }
