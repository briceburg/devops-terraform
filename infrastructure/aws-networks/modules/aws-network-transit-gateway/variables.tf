variable "allowed_transit_cidrs" {
  description = "network ranges allowed to traverse through this transit gateway"
  type        = list(string)
  # align with ranges of networks expected to route through transit gateways
  # https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-nat-igw.html#transit-gateway-nat-igw-nat-vpc-c-route-tables
  default = [
    "10.0.0.0/8",
    "172.30.0.0/16",
  ]
}
variable "asn" {
  description = "Amazon side ASN of this transit gateway. If empty, ASN will be based on network stage."
  type        = number
  default     = null
}

variable "enable_sharing" {
  description = "When true, the transit gateway will be available to other accounts within the same organization tier."
  type        = bool
  default     = true
}

variable "network" {
  description = "Network to utilize. Networks are provided by the infrastrucute/aws-networks Terraform."
  type = object({
    egress = object({
      ips      = list(string)
      gateways = list(string)
    })
    id    = string
    stage = string
    vpc = object({
      id           = string
      route_tables = map(list(string))
      subnet_ids   = map(list(string))
    })
  })
}
