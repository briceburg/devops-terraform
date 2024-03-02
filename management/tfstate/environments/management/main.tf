module "config" {
  source = "../../modules/config"
  tier   = basename(abspath(path.root))
}

provider "aws" {
  region              = module.config.region
  allowed_account_ids = [module.config.account_id]

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
