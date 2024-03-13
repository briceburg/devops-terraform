variable "org_data" {}

variable "ou_paths" {
  description = "list of OU paths to apply the policy to. if empty, the SCP will be applied to root OU and effect all accounts across all organizations."
  type        = list(string)
  default     = ["."]
}

variable "policy_content" {
  description = "policy text"
  type        = string
}

variable "policy_name" {
  description = "name of SCP"
  type        = string
}
