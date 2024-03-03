variable "availability_zones" {
  description = "list of availability zones. if empty, 3 from the target region will be utilized."
  type        = list(string)
  default     = []
}
variable "cidr" {
  description = "VPC CIDR. if empty, it will be assigned based on the network 'id'."
  type        = string
  default     = ""
}
variable "enable_transit_gateway" {
  description = "if true, transit gateways will be added to this network."
  type        = bool
  default     = false
}
variable "id" {
  description = "unique network name/identifier"
  type        = string
}
variable "routing" {
  description = "'self' or 'transit'. determines if outbound traffic is routed through the transit_network ('transit'), or its own unique NAT gateways ('self')."
  type        = string
  default     = "transit"
  validation {
    condition     = contains(["self", "transit"], var.routing)
    error_message = "invalid routing"
  }
}
variable "stage" {
  description = "the stage determines certain configurations, such as the spread of NAT gateways across Availability Zonnes."
  type        = string
  default     = "DEVELOPMENT"
  validation {
    condition     = contains(["PRODUCTION", "DEVELOPMENT"], var.stage)
    error_message = "unknown stage"
  }
}
variable "transit_network" {
  description = "when `var.routing` is 'transit', the network object to route outbound traffic through"
  default     = null
  validation {
    condition     = var.transit_network == null || can(var.transit_network.transit_gateway.id)
    error_message = "transit_network must contain a transit gateway"
  }
}
