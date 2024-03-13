locals {
  x_group_assignments = flatten([for email, u in var.users : [
    for group in u.groups : {
      email = email
      group = group
      key   = lower("${group}_${email}")
    }
  ]])
}
