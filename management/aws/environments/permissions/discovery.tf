module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery"

  lookups = ["org", "identities"]
}

module "org_data" {
  source = "github.com/briceburg/devops-terraform-modules//aws-org-data"
  bucket = module.discovery.lookup_results[0].data.bucket
  key    = module.discovery.lookup_results[0].data.key
}
