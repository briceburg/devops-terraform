locals {
  egress = {
    ips      = var.routing == "transit" ? var.transit_network.egress.ips : [for eip in aws_eip.private-outbound : eip.public_ip]
    gateways = var.routing == "transit" ? [var.transit_network.transit_gateway.id] : [for natgw in aws_nat_gateway.private-outbound : natgw.id]
  }
  eip_zones = {
    transit = []
    self    = contains(["PRODUCTION"], var.stage) ? module.config.vpc_availability_zones : [module.config.vpc_availability_zones[0]]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name       = var.id
    Network_ID = var.id
    Stage      = var.stage
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = var.routing == "transit" ? 1 : 0

  subnet_ids         = [for subnet in aws_subnet.private : subnet.id]
  transit_gateway_id = var.transit_network.transit_gateway.id
  vpc_id             = aws_vpc.this.id
}

resource "aws_eip" "private-outbound" {
  for_each   = toset(local.eip_zones[var.routing])
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name       = "${var.id}-outbound-${each.key}"
    Network_ID = var.id
    Stage      = var.stage
  }
}
resource "aws_nat_gateway" "private-outbound" {
  for_each      = aws_eip.private-outbound
  depends_on    = [aws_internet_gateway.this]
  allocation_id = each.value.id
  subnet_id     = aws_subnet.public[each.key].id
  tags = {
    Name       = "${var.id}-outbound-${each.key}"
    Network_ID = var.id
    Stage      = var.stage
  }
}

//
// Public Routes
//

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name       = "${var.id}-public"
    Network_ID = var.id
    Stage      = var.stage
    Tier       = "public"
  }
}

resource "aws_route" "public-outbound" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

//
// Private Routes
//

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.this.id
  tags = {
    Name       = "${var.id}-private-${each.key}"
    Network_ID = var.id
    Stage      = var.stage
    Tier       = "private"
  }
}

resource "aws_route" "private-outbound" {
  for_each               = aws_route_table.private
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.routing == "transit" ? null : try(aws_nat_gateway.private-outbound[each.key].id, local.egress.gateways[0])
  transit_gateway_id     = var.routing == "transit" ? local.egress.gateways[0] : null
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
