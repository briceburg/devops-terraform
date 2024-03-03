locals {
  azs = coalescelist(var.availability_zones, slice(sort(data.aws_availability_zones.prefered.names), 0, 3))

  #
  # CIDR reservations. 
  # NOTE: a unique CIDR is required for routing through the transit gateway
  # TODO: these should come from a data source or IPAM (https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html)
  #
  cidr = coalesce(var.cidr, try(local.cidr_reservations.by_id[var.network_id], local.cidr_reservations.default))
  cidr_reservations = {
    by_id = {
      # shared networks (larger to accomodate more IPs)
      "default" = "172.23.0.0/16"
      "devops"  = "10.10.0.0/16"
      "qa"      = "10.11.0.0/16"

      # namespace networks (for specific projects)
      "project-a" = "10.100.0.0/18"

      # testing networks
      "testing" = "172.30.50.0/24"

      # vendor peering networks (start at 172.30.100, then 172.30.101, ...)
      "prod-vendorname" = "172.30.100.0/24"
    }
    default = "10.255.0.0/20"
  }

  # align with ranges of networks expected to route through transit gateways
  # https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-nat-igw.html#transit-gateway-nat-igw-nat-vpc-c-route-tables
  allowed_transit_cidrs = [
    "10.0.0.0/8",
    "172.30.0.0/16",
  ]
}

