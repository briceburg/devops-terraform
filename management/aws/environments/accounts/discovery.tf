# allows organization data such as accounts to be discovered through
# a S3 bucket that is readable by entities within the organization

module "discovery_bucket" {
  source = "./modules/aws-org-discovery"

  allowed_principal_organizations = [aws_organizations_organization.root.id]
  bucket_name                     = lower("${aws_organizations_organization.root.id}-discovery")
  data = {
    accounts      = local.accounts
    ou_arn_prefix = local.ou_arn_prefix
    ou_paths      = local.ou_paths
  }
}


module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery"

  registrations = {
    "org" = {
      data = merge({
        id  = aws_organizations_organization.root.id
        arn = aws_organizations_organization.root.arn
      }, module.discovery_bucket)
    }
  }
}



