variable "enable_sharing" {
  description = "When true, prefix lists be shared and available to other accounts within the same organization tier."
  type        = bool
  default     = true
}

variable "managed_list_map" {
  description = "Map of prefix lists. Map key is an identifier, second map key describes a group of entries, and value is the entries -- a list of IPv4 or IPv6 CIDRs."
  type        = map(map(list(string)))
}
