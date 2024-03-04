output "shares" {
  value = {
    transit_gateways = [for r in aws_ram_resource_association.transit_gateways : r.id]
  }
}
