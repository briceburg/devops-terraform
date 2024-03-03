variable "organization_name" {
  description = "organization or company name"
  default     = "iceburg-devops"
}

variable "network_region" {
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

