variable "management_account_id" {
  description = "Account ID of the AWS Organization Management Account. https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html"
  type        = number
  default     = 211125402636
}

variable "management_aws_profile" {
  description = "local aws cli profile name for operating the management account"
  default     = "aws-org-management/operate"
}

variable "sso_region" {
  description = "SSO Region"
  default     = "us-east-2"
}

variable "sso_start_url" {
  description = "SSO Start/Login URL"
  default     = "https://d-9a67706e62.awsapps.com/start"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}

