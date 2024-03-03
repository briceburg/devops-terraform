output "cidr" {
  value = module.config.vpc_cidr
}

output "egress" {
  value = local.egress
}

output "id" {
  value = aws_vpc.this.id
  depends_on = [
    # delay output until routes are usable
    aws_route.private-outbound,
    aws_route.public-outbound,
  ]
}

output "lambda" {
  value = module.lambda
}

output "networks" {
  value = local.networks
}

output "route_tables" {
  value = local.route_tables
}

output "subnet_arns" {
  value = local.subnet_arns
  depends_on = [
    aws_route.private-outbound,
    aws_route.public-outbound
  ]
}

output "subnets" {
  value = {
    intra   = [for subnet in aws_subnet.intra : subnet.id]
    private = [for subnet in aws_subnet.private : subnet.id]
    public  = [for subnet in aws_subnet.public : subnet.id]
  }
  depends_on = [
    aws_route.private-outbound,
    aws_route.public-outbound
  ]
}

output "transit_gateway" {
  value = try(module.transit_gateway[0], null)
}
