output "github_oidc_roles" {
  value = {
    notprod = module.oidc_role_notprod
    prod    = {}
  }
}
