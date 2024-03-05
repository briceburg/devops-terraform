variable "apex_zone_root_domain" {
  description = "namespace apex zone root domain."
  default     = "namespaces.iceburg.net"
}

variable "organization_name" {
  description = "organization or company name"
  default     = "iceburg-devops"
}

variable "region" {
  description = "region for route53 resources"
  default     = "us-east-2"
}

variable "tier" {
  description = "account tier"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}

