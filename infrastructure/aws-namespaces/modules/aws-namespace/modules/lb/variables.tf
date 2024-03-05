variable "acm" {}
variable "bucket" {}
variable "namespace_id" {}
variable "route53" {}
variable "sg" {}
variable "ssl_policy" {}
variable "stage" {}
variable "subnets" {}

variable "id" {
  description = "LB to create. one of; public, trusted, nlb"
  type        = string

  validation {
    condition     = contains(["public", "trusted", "nlb"], var.id)
    error_message = "invalid load balancer id"
  }
}
