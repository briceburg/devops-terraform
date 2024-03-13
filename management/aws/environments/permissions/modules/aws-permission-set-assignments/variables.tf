variable "by_accounts" {
  description = "permission assignments by account names. matches the listed accounts."
  type = list(object({
    accounts = list(string)
    perms = list(object({
      groups          = list(string)
      permission_sets = list(string)
    }))
  }))
}

variable "by_groups" {
  description = "permission assignments by group names. matches the listed groups."
  type = list(object({
    groups = list(string)
    perms = list(object({
      accounts        = list(string)
      permission_sets = list(string)
    }))
  }))
}

variable "by_membership" {
  description = "permission assignments by membership. matches accounts that live within the given org(s), tier(s), and ou(s). If no membership for a given entity is provided, the empty list acts as a wildcard matching all accounts within."
  type = list(object({
    orgs  = optional(list(string), [])
    ous   = optional(list(string), [])
    tiers = optional(list(string), [])
    perms = list(object({
      groups          = list(string)
      permission_sets = list(string)
    }))
  }))
}

variable "instance_arn" {
  description = "sso instance ARN"
  type        = string
}

variable "management_groups" {
  description = "listed groups are granted access to the aws org management account"
  type        = list(string)
}
variable "management_permission_set" {
  description = "permission set/role given to listed management_groups"
  type        = string
}

variable "org_data" {}
variable "permission_sets" {}
