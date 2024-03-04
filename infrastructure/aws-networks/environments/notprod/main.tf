module "config" {
  source = "../../modules/config"
  tier   = "notprod"
}

provider "aws" {

  profile = "${module.config.tier}-network/operate"
  region  = module.config.region

  default_tags {
    tags = module.config.tags
  }
}

module "default_network" {
  source = "../../modules/aws-network"

  enable_transit_gateway = true
  id                     = "default"
  routing                = "self"
  stage                  = "DEVELOPMENT"
}

module "devops_network" {
  source = "../../modules/aws-network"

  id              = "devops"
  routing         = "transit"
  stage           = "DEVELOPMENT"
  transit_network = module.default_network
}

# module "prefix_lists" {
#   source = "../../modules/aws-prefix-lists"

#   prefix_list_map = {
#     developers = {
#       erika  = ["1.2.3.4/32", "2600:1700:500:8740::/64"]
#       darlan = ["5.6.7.8/32"]
#     }
#     metabase = {
#       # https://www.metabase.com/cloud/docs/ip-addresses-to-whitelist.html
#       metabase = ["18.207.81.126/32", "3.211.20.157/32", "50.17.234.169/32"]
#     }
#   }
# }

module "ram" {
  source = "../../modules/aws-ram-shares"

  organization_name    = module.config.organization_name
  tier                 = module.config.tier
  transit_gateway_arns = [module.default_network.transit_gateway.arn]
}
