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

module "org" {
  source = "./modules/aws-org"

  for_each = {
    "acme" = {
      account_email = {
        domain = "acme-org.com"
        user   = "devops"
      }

      accounts = {
        notprod = {
          infrastructure = []
          security       = []
          workloads      = []
        }
        prod = {
          infrastructure = []
          security       = []
          workloads = [
            "coyote"
          ]
        }
      }
    }

    "iceburg-devops" = {
      account_email = {
        domain = "iceburg-devops.com"
        user   = "devops"
      }

      accounts = {
        notprod = {
          infrastructure = [
            "network",
            "shared-services"
          ]
          security = [
            "logs",
            # commenting out to remain within free tier account number limitations
            #"security-tooling"
          ]
          workloads = [
            "sandbox"
          ]
        }
        prod = {
          infrastructure = [
            "network",
            "shared-services"
          ]
          security = [
            "logs",
            # commenting out to remain within free tier account number limitations
            #"security-tooling"
          ]
          workloads = [
            "sandbox"
          ]
        }
      }
    }
  }

  account_email     = each.value.account_email
  accounts          = each.value.accounts
  organization_name = each.key
  root_id           = local.root_id
}


resource "aws_organizations_organization" "root" {

  # WARNING: It is preferable to use CLI Tools/AWS Console for these. 
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html
  aws_service_access_principals = [
    "ram.amazonaws.com",
    "sso.amazonaws.com",
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]

  feature_set = "ALL"
}

# allow RAM shares within the organization
resource "aws_ram_sharing_with_organization" "this" {}
