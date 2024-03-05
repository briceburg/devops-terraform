data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "ForAnyValue:StringLike"
      values   = var.subject_claims
      variable = "token.actions.githubusercontent.com:sub"
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }

  version = "2012-10-17"
}

