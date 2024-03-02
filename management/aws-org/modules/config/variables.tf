variable "email" {
  description = "when accounts are created, they are given an email addess in the format: <user>+aws-<account-name>@<domain>, e.g. devops+aws-management@iceburg.net"
  type = object({
    domain = string
    user   = string
  })
  default = {
    domain = "iceburg.net"
    user   = "devops"
  }
}

variable "management_account_id" {
  description = "AWS Account ID of the Org Management Account"
  type        = number
  default     = 891377375061
}

variable "organization" {
  description = "organization or company name"
  default     = "iceburg-devops"
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

variable "sso_region" {
  description = "SSO Region"
  default     = "us-east-2"
}

variable "sso_start_url" {
  description = "Organization Start/Login URL"
  default     = "https://d-9a67708f86.awsapps.com/start"
}


variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}
