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

module "namespace_apex_zone" {
  source = "../../modules/namespace-apex-zone"

  tier = module.config.tier
}

output "namespace_apex_zone" {
  value = module.namespace_apex_zone
}
