locals {
  # public subnet is services needing a public IP, e.g. ALBs, NLBs
  # private subnet is for services which may require outbound traffic, e.g. ECS, Lambda
  # intra subnet is for services not requiring outbound traffic, e.g. RDS
  subnet_tiers = ["public", "private", "intra"]

  # split /20 vpc network into blocks for each subnet tier (2,2,1); 
  #   2: /22 "public"  (1022 Hosts/Net) 
  #   2: /22 "private" (1022 Hosts/Net) 
  #   1: /21 "intra"   (2046 Hosts/Net)
  cidrs = cidrsubnets(module.config.vpc_cidr, 2, 2, 1)

  # spread subnet tiers across three availability zones (1,2,2), e.g.;
  # "intra" = {
  #   "us-east-1a" = "10.255.8.0/22"
  #   "us-east-1b" = "10.255.12.0/23"
  #   "us-east-1c" = "10.255.14.0/23"
  # }
  # "private" = {
  #   "us-east-1a" = "10.255.4.0/23"
  #   "us-east-1b" = "10.255.6.0/24"
  #   "us-east-1c" = "10.255.7.0/24"
  # }
  # "public" = {
  #   "us-east-1a" = "10.255.0.0/23"
  #   "us-east-1b" = "10.255.2.0/24"
  #   "us-east-1c" = "10.255.3.0/24"
  # }
  networks = { for idx, tier in local.subnet_tiers : tier =>
    { for idx, cidr in cidrsubnets(local.cidrs[idx], 1, 2, 2) : module.config.vpc_availability_zones[idx] => cidr }
  }
}

locals {
  route_tables = {
    intra   = [aws_vpc.this.default_route_table_id]
    private = [for k, v in aws_route_table.private : v.id]
    public  = [aws_route_table.public.id]
  }
  subnet_arns = {
    intra   = [for subnet in aws_subnet.intra : subnet.arn]
    private = [for subnet in aws_subnet.private : subnet.arn]
    public  = [for subnet in aws_subnet.public : subnet.arn]
  }
  subnets = {
    intra   = [for subnet in aws_subnet.intra : subnet.id]
    private = [for subnet in aws_subnet.private : subnet.id]
    public  = [for subnet in aws_subnet.public : subnet.id]
  }
}
