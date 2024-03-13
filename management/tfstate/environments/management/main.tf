module "config" {
  source = "../../modules/config"
}

provider "aws" {
  allowed_account_ids = [module.config.management_account_id]
  profile             = "aws-org-management/operate"
  region              = module.config.region

  default_tags {
    tags = merge({ Tier = "management" }, module.config.tags)
  }
}


module "tfstate" {
  source = "github.com/briceburg/devops-terraform-modules//aws-tfstate-bucket"
}

output "tfstate" {
  value = {
    management = module.tfstate
  }
}
