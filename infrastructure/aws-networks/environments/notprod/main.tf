module "config" {
  source = "../../modules/config"
  tier   = "notprod"
}

provider "aws" {
  profile = "notprod-network/operate"
  region  = module.config.region

  default_tags {
    tags = module.config.tags
  }
}

module "default_network" {
  source = "../../modules/aws-network"

  id    = "default"
  stage = "DEVELOPMENT"
}

module "default_network_tgw" {
  source = "../../modules/aws-network-transit-gateway"

  network = module.default_network
}

module "devops_network" {
  source = "../../modules/aws-network"

  id              = "devops"
  stage           = "DEVELOPMENT"
  transit_gateway = module.default_network_tgw
}

module "prefix_lists" { # TODO: move to firewall terraform
  source = "../../modules/aws-prefix-lists"

  managed_list_map = {
    developers = {
      erika  = ["1.2.3.4/32", "2600:1700:500:8740::/64"]
      darlan = ["5.6.7.8/32"]
    }
    vendors = {
      # https://www.metabase.com/cloud/docs/ip-addresses-to-whitelist.html
      metabase = ["18.207.81.126/32", "3.211.20.157/32", "50.17.234.169/32"]
    }
    vpns = {
      azure-west = ["1.2.3.4/32"]
    }
  }
}

