variable "management_account_id" {
  description = "Account ID of the AWS Organization Management Account. https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html"
  type        = number
  default     = 211125402636
}

variable "organization_name" {
  description = "Parent organization name, e.g. 'iceburg'. Used as a bucket naming prefix."
  default     = "devops-terraform"
}

variable "shared_services_account_id_map" {
  description = "A tfstate bucket is added to the shared-services account for each 'tier'. E.g. a bucket for 'prod' state, and a separate bucket for 'notprod' state."
  type        = map(number)
  default = {
    # use account IDs for the appropriate shared-services accounts
    # created by the management/aws/environments/accounts terraform.
    # not needed for management tfstate, only project buckets.
    prod    = 851725570879
    notprod = 381491926522
  }
}

variable "state_region" {
  description = "region for holding terraform state resources"
  default     = "us-east-2"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}

