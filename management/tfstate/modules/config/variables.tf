variable "account_map" {
  description = "map of account ids. must inclucde 'management' key, and a key for every tier (e.g. 'prod', '...')"
  type        = map(number)
  default = {
    management = 891377375061

    # use account IDs for the appropriate shared-services account
    prod    = 123
    notprod = 123
  }
}

variable "organization" {
  description = "organization or company name"
  default     = "iceburg-devops"
}

variable "state_region" {
  description = "region for holding terraform state resources"
  default     = "us-east-2"
}

variable "tier" {
  description = "account tier"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}

