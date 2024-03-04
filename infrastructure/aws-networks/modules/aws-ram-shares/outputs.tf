output "shares" {
  value = {
    prefix_lists     = [for r in aws_ram_resource_association.prefix_lists : r.id]
    transit_gateways = [for r in aws_ram_resource_association.transit_gateways : r.id]
  }
}
