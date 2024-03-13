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

module "permission_sets" {
  source = "./modules/aws-permission-sets"

  permission_sets = {
    admin   = "Read/Write Access to all resources."
    operate = "Operate Access to terraformed resources."
    read    = "Read Access to terraformed resources."
  }

  permission_set_policies = {
    admin = {
      managed = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
    }
    operate = {
      managed = [
        # TODO: lock this down to actual resources managed by terraform
        "arn:aws:iam::aws:policy/PowerUserAccess",
        "arn:aws:iam::aws:policy/IAMFullAccess",
      ]
    }
    read = {
      managed = [
        "arn:aws:iam::aws:policy/job-function/SupportUser",
        "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/job-function/Billing",
        "arn:aws:iam::aws:policy/SecurityAudit",
      ]
      inline = templatefile("${path.module}/policies/read.tftpl", {})
    }
  }

  session_duration = "PT4H"
  instance_arn     = local.instance_arn
}

module "permission_set_assignments" {
  source = "./modules/aws-permission-set-assignments"

  # grants access to org sso management account
  management_groups         = ["admin", "prodeng"]
  management_permission_set = "operate"

  by_membership = [
    {
      # no selectors will match all accounts in every sub-organization.
      perms = [
        {
          groups          = ["admin"]
          permission_sets = ["admin"]
        },
        {
          groups          = ["prodeng"]
          permission_sets = ["operate", "read"]
        },
        {
          groups          = ["secops"]
          permission_sets = ["read"]
        },
      ]
    },
    {
      # match all accounts in the 'acme' sub-organization.
      orgs = ["acme"]
      perms = [
        {
          groups          = ["acme-admin"]
          permission_sets = ["admin", "operate", "read"]
        },
        {
          groups          = ["acme-support"]
          permission_sets = ["read"]
        }
      ]
    },
    {
      # match all accounts within the 'notprod' tier of every sub-organization.
      tiers = ["notprod"]
      perms = [
        {
          groups          = ["engineer"]
          permission_sets = ["read"]
        },
      ]
    },
    {
      # match all accounts in the 'security' OU of every sub-organization.
      ous = ["security"]
      perms = [
        {
          groups          = ["secops"]
          permission_sets = ["operate"]
        },
      ]
    },
    {
      # match all accounts in the 'workloads' OU within the 'prod' tier of every sub-organization.
      tiers = ["prod"]
      ous   = ["workloads"]
      perms = [
        {
          groups          = ["engineer"]
          permission_sets = ["read"]
        },
      ]
    },
  ]

  by_accounts = [
    {
      accounts = ["prod-coyote"]
      perms = [
        {
          groups          = ["engineer"]
          permission_sets = ["operate"]
        },
      ]
    }
  ]

  by_groups = [
    {
      groups = ["engineer"]
      perms = [
        {
          accounts        = ["notprod-shared-services"]
          permission_sets = ["operate"]
        },
      ]
    }
  ]

  instance_arn    = local.instance_arn
  org_data        = local.org_data
  permission_sets = module.permission_sets.permission_sets
}

#
# service control policies - attach to an OU and effect descendent accounts.
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_syntax.html
# https://aws.amazon.com/blogs/security/how-to-control-access-to-aws-resources-based-on-aws-account-ou-or-organization/
# https://aws.amazon.com/blogs/security/iam-share-aws-resources-groups-aws-accounts-aws-organizations/
#
module "scp" {
  source = "./modules/aws-service-control-policy"

  for_each = {
    DenyBasicBadBehaviors = {
      content = templatefile(
        "${path.module}/policies/scp/DenyBasicBadBehaviors.tftpl",
        {}
      )
      ou_paths = ["."] # "." match the root OU, so this effects every account.
    }

    DenyUnsupportedInstanceTypes = {
      content = templatefile(
        "${path.module}/policies/scp/DenyUnsupportedInstanceTypes.tftpl",
        { supported_types = ["t2.micro", "t2.small"] }
      )

      ou_paths = ["acme/notprod", "iceburg-devops/notprod"] # match accounts in the 'notprod' tier of the 'iceburg-devops' and 'acme' sub-organizations.
    }

    DenyUnsupportedRegions = {
      content = templatefile(
        "${path.module}/policies/scp/DenyUnsupportedRegions.tftpl",
        { supported_regions = ["us-east-2", "us-west-2"] }
      )
      ou_paths = ["iceburg-devops"] # match accounts in the 'iceburg-devops' sub-organization.
    }

    # TODO: Deny Cross-Tier Access SCP.
  }

  org_data       = local.org_data
  ou_paths       = each.value.ou_paths
  policy_content = each.value.content
  policy_name    = each.key
}


