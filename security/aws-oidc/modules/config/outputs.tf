output "iam_path" {
  value = var.iam_path
}

output "organization_name" {
  value = var.organization_name
}

output "tags" {
  value = {
    Application = "aws-oidc"
    Org         = var.organization_name
    Vcs-url     = var.vcs_url
    # TODO: Env tag based on root terraform name?
  }
}

