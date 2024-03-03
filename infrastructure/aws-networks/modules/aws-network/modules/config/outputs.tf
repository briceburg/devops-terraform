output "allowed_transit_cidrs" {
  value = local.allowed_transit_cidrs
}

output "vpc_availability_zones" {
  value = local.azs

  precondition {
    condition     = length(local.azs) == 3
    error_message = "Plese provide 3 availability zones"
  }
}

output "vpc_cidr" {
  value = local.cidr

  # ensure we aren't using the default CIDR when transit routing
  precondition {
    condition     = var.routing != "transit" || local.cidr != local.cidr_reservations.default
    error_message = "CIDR must have a unique reservation when using transit routing."
  }

  precondition {
    condition     = contains(["10", "172"], split(".", local.cidr)[0]) && contains(["255.255.255.0", "255.255.240.0", "255.255.192.0", "255.255.0.0"], cidrnetmask(local.cidr))
    error_message = "Please pass a /24, /20, /18, or /16 network in the Class A or B Private Internet ranges."
  }
}


