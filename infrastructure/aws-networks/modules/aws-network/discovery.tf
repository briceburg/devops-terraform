locals {
  discovery_path = "/discovery/v1/networks/${var.id}"
  discovery_params = {
    cidr            = module.config.vpc_cidr
    egress          = local.egress
    id              = aws_vpc.this.id
    networks        = local.networks
    route_tables    = local.route_tables
    subnet_arns     = local.subnet_arns
    subnets         = local.subnets
    transit_gateway = try(module.transit_gateway[0], null)
  }
}

resource "aws_ssm_parameter" "discovery" {
  for_each = local.discovery_params
  name     = "${local.discovery_path}/${each.key}"
  type     = "String"
  value    = jsonencode(each.value)
}
