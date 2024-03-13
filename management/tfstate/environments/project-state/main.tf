# TODO: revisit when https://github.com/hashicorp/terraform/issues/24476 resolves

module "config" {
  source = "../../modules/config"
}

provider "aws" {
  alias               = "notprod"
  allowed_account_ids = [module.config.shared_services_account_id_map.notprod]
  profile             = "notprod-shared-services/operate"
  region              = module.config.region

  default_tags {
    tags = merge({ Tier = "notprod" }, module.config.tags)
  }
}

provider "aws" {
  alias               = "prod"
  allowed_account_ids = [module.config.shared_services_account_id_map.prod]
  profile             = "prod-shared-services/operate"
  region              = module.config.region

  default_tags {
    tags = merge({ Tier = "prod" }, module.config.tags)
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
