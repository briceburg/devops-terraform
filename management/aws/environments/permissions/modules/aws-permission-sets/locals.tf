locals {
  x_inline_policies = {
    for permission_set, policies in var.permission_set_policies : permission_set =>
    policies.inline if trimspace(try(policies.inline, "")) != ""
  }

  x_managed_policies = flatten([
    for permission_set, policies in var.permission_set_policies : [
      for arn in policies.managed : {
        key            = "${permission_set}_${regex(".*/(.*)$", arn)[0]}"
        permission_set = permission_set
        policy_arn     = arn
      }
    ]
  ])
}
