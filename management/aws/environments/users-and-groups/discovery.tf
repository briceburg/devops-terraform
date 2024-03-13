module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery"

  registrations = {
    "identities" = module.users_and_groups
  }
}


