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
