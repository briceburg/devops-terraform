module "config" {
  source = "../../modules/config"
}

# TODO: revisit when https://github.com/hashicorp/terraform/issues/24476 resolves, or terraform 'stacks' is available.

resource "aws_iam_openid_connect_provider" "notprod" {
  client_id_list  = ["https://github.com/briceburg", "sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  url             = "https://token.actions.githubusercontent.com"
  tags = {
    "Name" = "GitHub Actions OIDC provider"
  }

  provider = aws.notprod
}

module "oidc_role_notprod" {
  source     = "../../modules/github-actions-oidc-role"
  depends_on = [aws_iam_openid_connect_provider.notprod]

  iam_path = module.config.iam_path

  subject_claims = [ # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
    "repo:briceburg/devops-terraform:*"
  ]

  providers = {
    aws = aws.notprod
  }
}

#
# allow the github oidc role to assume CI roles in different accounts
# TODO: it may be best to use CDK and/or terraform stacks (when released) for provider configuration
#       alternatively the ci roles should be created by account baseline
#

# resource "aws_iam_role" "notprod_network_operate" {
#   assume_role_policy    = data.aws_iam_policy_document.assume_role.json
#   description           = var.iam_role_description
#   force_detach_policies = true
#   max_session_duration  = var.max_session_duration
#   name                  = var.iam_role_name
#   path                  = var.iam_path

#   provider = aws.notprod-network
# }

# resource "aws_iam_role" "notprod_network_read" {
#   assume_role_policy    = data.aws_iam_policy_document.assume_role.json
#   description           = var.iam_role_description
#   force_detach_policies = true
#   max_session_duration  = var.max_session_duration
#   name                  = var.iam_role_name
#   path                  = var.iam_path

#   provider = aws.notprod-network
# }















