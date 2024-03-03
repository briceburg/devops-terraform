locals {
  permission_set_policies = {
    admin = {
      managed = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
      inline = []
    }
    operate = {
      managed = [
        # TODO: lock this down to actual resources managed by terraform
        "arn:aws:iam::aws:policy/PowerUserAccess",
        "arn:aws:iam::aws:policy/IAMFullAccess",
      ]
      inline = []
    }
    read = {
      managed = [
        "arn:aws:iam::aws:policy/job-function/SupportUser",
        "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/job-function/Billing",
        "arn:aws:iam::aws:policy/SecurityAudit",
      ]
      inline = [
        templatefile("${path.module}/policies/read.tftpl", {
          org_id = var.organization_id
        })
      ]
    }
  }

  x_permissions_by_account = flatten([for account, perms in var.permissions_by_account : [
    for x in perms : [
      for p in setproduct(x.groups, x.permission_sets) : {
        account        = account
        group          = p[0]
        permission_set = p[1]
      }
    ]
    ]
  ])

  x_permissions_by_group = flatten([for group, perms in var.permissions_by_group : [
    for x in perms : [
      for p in setproduct(x.accounts, x.permission_sets) : {
        account        = p[0]
        group          = group
        permission_set = p[1]
      }
    ]
    ]
  ])

  x_permissions_by_ou = flatten([for selector, perms in var.permissions_by_ou : [
    for account in var.accounts : [
      for x in perms : [
        for p in setproduct(x.groups, x.permission_sets) : {
          account        = account.name
          group          = p[0]
          permission_set = p[1]
        }
      ]
    ] if selector == "." || startswith(lower(account.ou_selector), lower(selector))
  ]])

  x_permissions = merge(
    { for p in local.x_permissions_by_account : lower("${p.account}-${p.group}-${p.permission_set}") => p... },
    { for p in local.x_permissions_by_group : lower("${p.account}-${p.group}-${p.permission_set}") => p... },
    { for p in local.x_permissions_by_ou : lower("${p.account}-${p.group}-${p.permission_set}") => p... },
  )
}
