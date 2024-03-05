resource "aws_iam_role" "github" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  description           = var.iam_role_description
  force_detach_policies = true
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_path
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "assume_operate_roles" { # TODO: pass individual account roles vs wildcard
  name = "github_actions_assume_operate_roles"
  path = var.iam_path
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::*:role/ci_operate"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "assume_operate_roles" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.assume_operate_roles.arn
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "assume_read_roles" { # TODO: pass individual account roles vs wildcard
  name = "github_actions_assume_read_roles"
  path = var.iam_path
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::*:role/ci_read"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "assume_read_roles" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.assume_read_roles.arn
}
