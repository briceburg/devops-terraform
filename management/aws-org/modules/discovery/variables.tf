variable "organization_id" {
  description = "Organization ID allowed access to discovery bucket, e.g. o-xxxxxxx"
  type        = string
}

variable "accounts" {
  description = "Account mappings"
}

variable "ou_paths" {
  description = "OU Path mappings"
}

