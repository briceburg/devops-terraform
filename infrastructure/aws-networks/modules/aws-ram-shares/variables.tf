
variable "prefix_list_arns" {
  description = "ARNs of prefix lists to share"
  type        = list(string)
  default     = []
}
variable "organization_name" {}
variable "tier" {}
variable "transit_gateway_arns" {
  description = "ARNs of transit gateways to share"
  type        = list(string)
  default     = []
}





