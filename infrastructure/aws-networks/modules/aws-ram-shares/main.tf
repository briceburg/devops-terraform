#
# share transit gateways
#

resource "aws_ram_resource_share" "transit_gateways" {
  name                      = "${var.tier}-transit-gateways"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "transit_gateways" {
  for_each = toset(local.ram_share_prinicipal_arns)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.transit_gateways.id
}

resource "aws_ram_resource_association" "transit_gateways" {
  for_each = toset(var.transit_gateway_arns)

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.transit_gateways.id
}
