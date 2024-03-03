locals {
  permission_set_policies = {
    admin = {
      managed = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
    }
    operate = {
      managed = [
        # TODO: lock this down to actual resources managed by terraform
        "arn:aws:iam::aws:policy/PowerUserAccess",
        "arn:aws:iam::aws:policy/IAMFullAccess",
      ]
    }
    read = {
      managed = [
        "arn:aws:iam::aws:policy/job-function/SupportUser",
        "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/job-function/Billing",
        "arn:aws:iam::aws:policy/SecurityAudit",
      ]
      inline = templatefile("${path.module}/policies/read.tftpl", {
        org_id = var.organization_id
      })
    }
  }

  x_inline_policies = {
    for permission_set, policies in local.permission_set_policies : permission_set =>
    policies.inline if trimspace(try(policies.inline, "")) != ""
  }

  x_managed_policies = flatten([
    for permission_set, policies in local.permission_set_policies : [
      for arn in policies.managed : {
        key            = "${permission_set}_${regex(".*/(.*)$", arn)[0]}"
        permission_set = permission_set
        policy_arn     = arn
      }
    ]
  ])

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
    for account in var.accounts.accounts : [
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

#
# service control policies
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_syntax.html
# https://aws.amazon.com/blogs/security/how-to-control-access-to-aws-resources-based-on-aws-account-ou-or-organization/
# https://aws.amazon.com/blogs/security/iam-share-aws-resources-groups-aws-accounts-aws-organizations/
#

locals {
  service_control_policies = {
    DenyBasicBadBehaviors = {
      content = templatefile(
        "${path.module}/policies/scp/DenyBasicBadBehaviors.tftpl",
        {}
      )
      ou_selectors = [var.organization_name]
    }

    DenyUnsupportedInstanceTypes = {
      content = templatefile(
        "${path.module}/policies/scp/DenyUnsupportedInstanceTypes.tftpl",
        { supported_types = var.supported_instance_types }
      )
      # match only notprod tiers. 
      # TODO: do not hardcode this
      ou_selectors = ["${var.organization_name}.notprod"]
    }

    DenyUnsupportedRegions = {
      content = templatefile(
        "${path.module}/policies/scp/DenyUnsupportedRegions.tftpl",
        { supported_regions = var.supported_regions }
      )
      ou_selectors = [var.organization_name]
    }
  }

  x_scp_attachments = flatten([
    for scp_name, v in local.service_control_policies : [
      for selector in v.ou_selectors : {
        key         = "${scp_name}_${selector}"
        scp_name    = scp_name
        ou_selector = selector
      }
    ]
  ])
}
