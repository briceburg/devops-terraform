# find default VPC of current account
data "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"
}

module "discovery" {
  source  = "github.com/briceburg/devops-terraform-modules//aws-discovery" # TODO: use relative paths
  lookups = ["namespace-apex-zone"]

  providers = {
    aws = aws.ram
  }
}

locals {
  apex_zone = module.discovery.lookup_results[0]
}
