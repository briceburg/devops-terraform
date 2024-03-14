module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery" # TODO: use relative path
  registrations = {
    "networks/${var.id}" = {
      egress   = local.egress
      id       = var.id
      networks = local.networks
      stage    = var.stage
      vpc = {
        cidr         = module.config.vpc_cidr
        id           = aws_vpc.this.id
        route_tables = local.route_tables
        subnet_arns  = local.subnet_arns
        subnet_ids   = local.subnet_ids
      }
    }
  }
}
