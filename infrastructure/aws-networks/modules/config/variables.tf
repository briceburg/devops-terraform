# TODO: is it possible to use org-data for this before an initial provider is configured?
variable "organization_name" {
  description = "organization or company name"
  default     = "iceburg-devops"
}

variable "network_region" {
  description = "region for network resources"
  default     = "us-east-2"
}

variable "tier" {
  description = "account tier"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}

