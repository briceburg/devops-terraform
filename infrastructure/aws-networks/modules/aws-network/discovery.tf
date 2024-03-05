module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery"
  registrations = {
    "networks/${var.id}" = {
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
}
