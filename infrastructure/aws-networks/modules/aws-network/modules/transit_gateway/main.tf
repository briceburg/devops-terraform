resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.id}-transit-gateway"
  amazon_side_asn                 = var.stage == "PRODUCTION" ? 65533 : 64513
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id
}

resource "aws_ec2_transit_gateway_route" "this" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.this.association_default_route_table_id
}

resource "aws_route" "this" {
  for_each = toset(var.allowed_transit_cidrs)

  # https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-nat-igw.html#transit-gateway-nat-igw-nat-vpc-c-route-tables
  destination_cidr_block = each.value
  route_table_id         = var.public_route_table_id
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}
