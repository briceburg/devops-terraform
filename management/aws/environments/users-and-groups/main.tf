module "config" {
  source = "../../modules/config"
}

provider "aws" {
  allowed_account_ids = [module.config.management_account_id]
  profile             = module.config.management_aws_profile
  region              = module.config.sso_region

  default_tags {
    tags = module.config.tags
  }
}

data "aws_ssoadmin_instances" "this" {}


module "users_and_groups" {
  source = "./modules/aws-org-users-and-groups"

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  groups = {
    acme-admin   = "acme administrative group"
    acme-support = "acme support group"
    admin        = "administrative group"
    engineer     = "engineering group"
    prodeng      = "production engineering"
    secops       = "security and operations engineering"
  }

  users = {
    "admin@org.com" = {
      name   = "Org Admin"
      groups = ["acme-admin", "admin"]
    }
    "darlan.barr@org.com" = {
      name   = "Darlan E. Barr"
      groups = ["secops", "prodeng"]
    }
    "moss.andrews@org.com" = {
      name   = "Moss Andrews-Sanchez"
      groups = ["engineer"]
    }
    "robin.smith@org.com" = {
      name   = "Robin Smith"
      groups = ["prodeng"]
    }
    "support@org.com" = {
      name   = "Support User"
      groups = ["acme-support"]
    }
  }
}


