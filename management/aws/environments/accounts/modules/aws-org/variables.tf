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

variable "organization_name" {
  description = "organization or company name"
}

variable "root_id" {
  description = "OU root ID"
}
