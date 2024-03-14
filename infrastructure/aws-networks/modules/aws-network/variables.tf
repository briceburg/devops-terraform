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

variable "enable_sharing" {
  description = "When true, the networks subnets will be available to other accounts within the same organization tier."
  type        = bool
  default     = true
}

variable "id" {
  description = "unique network name/identifier"
  type        = string
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
variable "transit_gateway" {
  description = "if provided, outbound traffic will be routed through the transit gateway. the aws-transit-gateway module is used for managing transit gateways."
  type = object({
    arn        = string
    egress     = map(list(string))
    id         = string
    network_id = string
  })
  default = null
}
