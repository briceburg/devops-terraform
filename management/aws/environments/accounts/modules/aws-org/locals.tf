# locals {
#   data = {
#     accounts = module.accounts.accounts
#     ou_paths = merge([for k, v in module.ou_tree : v.paths]...)
#   }
# }

locals {
  data = {
    accounts = { for name, a in module.accounts.accounts : a.id => {
      name = name
      org  = var.organization_name
      ou   = split("/", a.ou_path)[1]
      tier = split("/", a.ou_path)[0]
    } }
    ou_paths = { for k, v in merge([for k, v in module.ou_tree : v.paths]...) : replace("${var.organization_name}/${k}", "/.", "") => v }
  }
}

