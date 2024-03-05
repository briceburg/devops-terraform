module "config" {
  source = "../../modules/config"
  tier   = "notprod"
}

provider "aws" {

  # TODO: have config module determine target account?
  profile = "${module.config.tier}-sandbox/operate"
  region  = module.config.region

  default_tags {
    tags = module.config.tags
  }
}

provider "aws" {
  alias = "network"

  # TODO: have config module determine network account?
  profile = "${module.config.tier}-network/operate"
  region  = module.config.region

  default_tags {
    tags = module.config.tags
  }
}

module "namespace" {
  source = "../../modules/aws-namespace"

  id             = "team-sky" # basename(abspath(path.root)) works as well
  load_balancers = []
  network_id     = "devops"
  stage          = "DEVELOPMENT"

  providers = {
    aws     = aws
    aws.dns = aws.network
    aws.ram = aws.network
  }
}

output "namespace" {
  value = module.namespace
}
