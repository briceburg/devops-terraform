variable "allowed_principal_organizations" {
  description = "listed principals can read from this bucket"
  type        = list(string)
}

variable "bucket_name" {
  description = "Name of Organiztion Discovery Bucket"
}

variable "data" {
  description = "Organization Data Object"
}
