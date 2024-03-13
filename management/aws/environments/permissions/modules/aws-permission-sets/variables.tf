variable "permission_sets" {
  description = "map of permission sets. map key is permission set name, value is description."
  type        = map(string)
}

variable "permission_set_policies" {
  description = "map of permission set policies. map key is permission set name, value is an object containing an optional list of managed policies and an optional inline policy."
  type = map(object({
    managed = optional(list(string), [])
    inline  = optional(string, "")
  }))
}

variable "session_duration" {
  description = "The length of time that user sessions are valid in ISO-8601 standard."
  type        = string
  default     = "PT4H"
}

variable "instance_arn" {
  description = "sso instance ARN"
  type        = string
}
