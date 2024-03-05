variable "id" {
  description = "Namespace ID."
  type        = string
}

variable "lambda_functions" {
  description = "Optional. List of lambda functions to enable in this namespace. e.g. ['outbound-ip']"
  default     = []
  type        = list(string)
  validation {
    condition     = alltrue([for v in var.lambda_functions : contains(["outbound-ip"], v)])
    error_message = "Unknown lambda function. Valid values are 'outbound-ip'."
  }
}

variable "load_balancers" {
  description = "Optional. Load balancers to add to this namespace. ['public', 'trusted', 'nlb']"
  default     = []
  type        = list(string)

  validation {
    condition     = alltrue([for v in var.load_balancers : contains(["public", "trusted", "nlb"], v)])
    error_message = "Unknown load balancer. Valid values are 'public', 'trusted', 'nlb'."
  }
}

variable "network_id" {
  description = "Namespace Network Identifier. Networks are provided by the infrastrucute/aws-networks Terraform."
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

variable "ssl_policy" {
  type        = string
  description = "https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

