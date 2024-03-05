variable "iam_path" {
  default     = "/oidc/"
  description = "Path to the IAM roles."
  type        = string
}

variable "organization_name" {
  description = "organization or company name"
  default     = "iceburg-devops"
}

variable "vcs_url" {
  description = "URL/Repository holding terraform configuration"
  default     = "https://github.com/briceburg/devops-terraform.git"
}


