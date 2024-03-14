module "config" {
  source = "./modules/config"

  availability_zones = var.availability_zones
  cidr               = var.cidr
  network_id         = var.id
  routing            = local.enable_tgw ? "transit" : "self"
}

resource "aws_vpc" "this" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = module.config.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    Name       = var.id
    Network_ID = var.id
    Stage      = var.stage
  }
}

resource "aws_subnet" "public" {
  for_each                = toset(module.config.vpc_availability_zones)
  depends_on              = [aws_internet_gateway.this]
  availability_zone       = each.value
  cidr_block              = local.networks["public"][each.value]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.this.id
  tags = {
    Name       = "${var.id}-public-${each.value}"
    Network_ID = var.id
    Stage      = var.stage
    Tier       = "public"
  }
}

resource "aws_subnet" "private" {
  for_each                = toset(module.config.vpc_availability_zones)
  availability_zone       = each.value
  cidr_block              = local.networks["private"][each.value]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id
  tags = {
    Name       = "${var.id}-private-${each.value}"
    Network_ID = var.id
    Stage      = var.stage
    Tier       = "private"
  }
}

resource "aws_subnet" "intra" {
  for_each                = toset(module.config.vpc_availability_zones)
  availability_zone       = each.value
  cidr_block              = local.networks["intra"][each.value]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id
  tags = {
    Name       = "${var.id}-intra-${each.value}"
    Network_ID = var.id
    Stage      = var.stage
    Tier       = "intra"
  }
}

module "lambda" {
  source = "./modules/lambda"

  functions  = ["outbound-ip"]
  id         = "network-${var.id}"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
  vpc_id     = aws_vpc.this.id
}

module "ram_share" {
  source = "github.com/briceburg/devops-terraform-modules//aws-ram-share"
  count  = var.enable_sharing ? 1 : 0

  name = "network-${var.id}-subnets"
  resources = merge(
    { for k, v in aws_subnet.intra : "intra-${k}" => v.arn },
    { for k, v in aws_subnet.private : "private-${k}" => v.arn },
    { for k, v in aws_subnet.public : "public-${k}" => v.arn },
  )
}


