module "config" {
  source = "../../modules/config"
  tier   = basename(abspath(path.root))
}

provider "aws" {
  allowed_account_ids = [module.config.account_id]
  profile             = "iceburg-management/operate"
  region              = module.config.region

  default_tags {
    tags = module.config.tags
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
