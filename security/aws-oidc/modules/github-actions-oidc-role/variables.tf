variable "subject_claims" {
  type        = list(string)
  description = "List of GitHub subject claims. https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect"
}

variable "iam_path" {
  default     = "/oidc"
  description = "Path to the IAM role."
  type        = string
}

variable "iam_role_description" {
  default     = "GitHub Actions OIDC Role."
  description = "Description of OIDC Role."
  type        = string
}

variable "iam_role_name" {
  default     = "github-actions"
  description = "Name of OIDC Role."
  type        = string
}

variable "max_session_duration" {
  default     = 3600
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 1 and 12 hours."
  }
}

