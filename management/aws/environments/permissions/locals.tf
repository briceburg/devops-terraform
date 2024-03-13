locals {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  org_data = merge(
    # org data.json contains accounts and ou_path information.
    # users and groups are withheld as they are sensitive.
    # augment by discovering via SSM in the management account.
    {
      groups = module.discovery.lookup_results[1].groups
      users  = module.discovery.lookup_results[1].users
    },
    module.org_data.org_data
  )
}

