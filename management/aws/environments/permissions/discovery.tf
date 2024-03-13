module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery"

  lookups = ["org", "identities"]
}





