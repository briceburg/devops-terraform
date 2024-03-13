locals {
  every = { # all possible organization/ou/tier names
    org  = distinct([for a in var.org_data.accounts : a.org])
    ou   = distinct([for a in var.org_data.accounts : a.ou])
    tier = distinct([for a in var.org_data.accounts : a.tier])
  }

  x_permissions_by_account = flatten([for i in var.by_accounts : [
    for account_name in i.accounts : [
      for p in i.perms : [
        for x in setproduct(p.groups, p.permission_sets) : {
          account        = account_name
          group          = x[0]
          permission_set = x[1]
        }
      ]
  ]]])

  x_permissions_by_group = flatten([for i in var.by_groups : [
    for group_name in i.groups : [
      for p in i.perms : [
        for x in setproduct(p.accounts, p.permission_sets) : {
          account        = x[0]
          group          = group_name
          permission_set = x[1]
        }
      ]
  ]]])

  x_permissions_by_membership = flatten([for i in var.by_membership : [
    for account_id, account in var.org_data.accounts : [
      for p in i.perms : [
        for x in setproduct(p.groups, p.permission_sets) : {
          account        = account.name
          group          = x[0]
          permission_set = x[1]
        }
      ]
    ] if contains(coalescelist(i.orgs, local.every.org), account.org)
    && contains(coalescelist(i.tiers, local.every.tier), account.tier)
    && contains(coalescelist(i.ous, local.every.ou), account.ou)
  ]])

  x_permissions = merge(
    { for p in local.x_permissions_by_account : lower("${p.account}/${p.group}/${p.permission_set}") => p... },
    { for p in local.x_permissions_by_group : lower("${p.account}/${p.group}/${p.permission_set}") => p... },
    { for p in local.x_permissions_by_membership : lower("${p.account}/${p.group}/${p.permission_set}") => p... },
  )
}
