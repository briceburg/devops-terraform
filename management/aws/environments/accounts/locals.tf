locals {
  accounts = merge([for k, v in module.org : v.accounts]...)
  ou_paths = merge({ "." = local.root_id }, [for k, v in module.org : v.ou_paths]...)
  ou_arn_prefix = replace(
    aws_organizations_organization.root.arn,
    ":organization/",
    ":ou/"
  )

  root_id = aws_organizations_organization.root.roots[0].id
}
