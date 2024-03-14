output "egress" {
  value = local.egress
}

output "id" {
  value = var.id
}

output "networks" {
  value = local.networks
}

output "stage" {
  value = var.stage
}

output "vpc" {
  value = {
    cidr         = module.config.vpc_cidr
    id           = aws_vpc.this.id
    route_tables = local.route_tables
    subnet_arns  = local.subnet_arns
    subnet_ids   = local.subnet_ids
  }
}
