variable "account_email" {
  description = "when accounts are created, they are given an email addess in the format: <user>+aws-<account-name>@<domain>, e.g. devops+aws-management@iceburg.net"
  type = object({
    domain = string
    user   = string
  })
}

variable "accounts" {
  description = "mapping of organization accounts to create. first key is 'tier', second is supporting OU containg a list of account names"
  type        = map(map(list(string)))
  default = {
    production = {
      infrastructure = [
        "network",
        "shared-services",
      ]
      security = [
        "logs",
        "security-tooling",
      ]
      workloads = []
    }
  }
}

variable "groups" {
  description = "mapping of SSO user groups. key is group name, value is description"
  type        = map(string)
}

variable "management_account_id" {
  description = "AWS Account ID of the Org Management Account"
  type        = number
}

variable "management_groups" {
  description = "groups allowed to access the management account"
  type        = list(string)
}
variable "management_permission_set" {
  description = "permission set given to groups allowed access to the management account"
}

variable "organization" {
  description = "organization or company name"
}

variable "organization_trusted_services" {
  description = "WARNING: It is preferable to use CLI Tools/AWS Console for these. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html"
  type        = list(string)
  default = [
    "ram.amazonaws.com",
    "sso.amazonaws.com",
    #"cloudtrail.amazonaws.com",
    #"config.amazonaws.com",
    #"guardduty.amazonaws.com",
    #"securityhub.amazonaws.com",
  ]
}

variable "permission_sets" {
  description = "mapping of SSO permission sets. key is permission name, value is description"
  type        = map(string)

}

variable "permissions_by_account" {
  description = "defines the groups and permission sets assigned to specific accounts. key is account name."
  type = map(list(object({
    groups          = list(string)
    permission_sets = list(string)
  })))
}

variable "permissions_by_group" {
  description = "defines the accounts and permission sets assigned to specific groups. key is group name."
  type = map(list(object({
    accounts        = list(string)
    permission_sets = list(string)
  })))
}

variable "permissions_by_ou" {
  description = "defines the groups and permission sets assigned to accounts under a matching OU. key is OU selector, '.' matches all OUs/accounts."
  type = map(list(object({
    groups          = list(string)
    permission_sets = list(string)
  })))
}

variable "sso_region" {
  description = "SSO Region"
}

variable "sso_start_url" {
  description = "Organization Start/Login URL"
}

variable "users" {
  description = "mapping of SSO users. key is user's email."
  type = map(object({
    name   = string       # user's name
    groups = list(string) # user's groups
  }))
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
}
