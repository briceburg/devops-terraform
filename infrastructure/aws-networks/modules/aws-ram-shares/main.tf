#
# share transit gateways
#

resource "aws_ram_resource_share" "transit_gateways" {
  name                      = "${var.tier}-transit-gateways"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "transit_gateways" {
  for_each = { for arn in local.ram_share_prinicipal_arns : regex(".*/(.*)$", arn)[0] => arn }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.transit_gateways.id
}

resource "aws_ram_resource_association" "transit_gateways" {
  for_each = { for arn in var.transit_gateway_arns : regex(".*/(.*)$", arn)[0] => arn }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.transit_gateways.id
}

#
# share prefix lists
#

resource "aws_ram_resource_share" "prefix_lists" {
  name                      = "${var.tier}-prefix-lists"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "prefix_lists" {
  for_each = { for arn in local.ram_share_prinicipal_arns : regex(".*/(.*)$", arn)[0] => arn }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.prefix_lists.id
}

resource "aws_ram_resource_association" "prefix_lists" {
  for_each = { for arn in var.prefix_list_arns : regex(".*/(.*)$", arn)[0] => arn }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.prefix_lists.id
}

#
# share network subnets
#

resource "aws_ram_resource_share" "subnets" {
  name                      = "${var.tier}-subnets"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "subnets" {
  for_each = { for arn in local.ram_share_prinicipal_arns : regex(".*/(.*)$", arn)[0] => arn }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.subnets.id
}

resource "aws_ram_resource_association" "subnets" {
  for_each = { for arn in var.subnet_arns : regex(".*/(.*)$", arn)[0] => arn }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.subnets.id
}

