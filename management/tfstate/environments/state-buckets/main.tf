# TODO: revisit when https://github.com/hashicorp/terraform/issues/24476 resolves

module "config" {
  for_each = toset(["prod", "notprod"])

  source = "../../modules/config"
  tier   = each.value
}

provider "aws" {
  alias               = "notprod"
  allowed_account_ids = [module.config["notprod"].account_id]
  profile             = "notprod-shared-services/operate"
  region              = module.config["notprod"].region

  default_tags {
    tags = module.config["notprod"].tags
  }
}

provider "aws" {
  alias               = "prod"
  allowed_account_ids = [module.config["prod"].account_id]
  profile             = "prod-shared-services/operate"
  region              = module.config["prod"].region

  default_tags {
    tags = module.config["prod"].tags
  }
}

module "tfstate_notprod" {
  source = "github.com/briceburg/devops-terraform-modules//aws-tfstate-bucket"
  providers = {
    aws = aws.notprod
  }
}

module "tfstate_prod" {
  source = "github.com/briceburg/devops-terraform-modules//aws-tfstate-bucket"
  providers = {
    aws = aws.prod
  }
}

output "tfstate" {
  value = {
    notprod = module.tfstate_notprod
    prod    = module.tfstate_prod
  }
}
