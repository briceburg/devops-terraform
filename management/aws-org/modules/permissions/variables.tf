variable "accounts" {}
variable "groups" {}
variable "instance_arn" {}
variable "management_account_id" {}
variable "management_groups" {}
variable "management_permission_set" {}
variable "organization_id" {}
variable "organization_name" {}
variable "permission_sets" {} # TODO: validate passed permissions have a policy
variable "permissions_by_account" {}
variable "permissions_by_group" {}
variable "permissions_by_ou" {}
variable "session_duration" {
  description = "The length of time that the application user sessions are valid in the ISO-8601 standard."
  default     = "PT4H"
}
variable "supported_instance_types" {}
variable "supported_regions" {}

