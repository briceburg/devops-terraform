locals {
  path   = "/namespaces/"
  prefix = "${var.namespace_id}-"
  policies = {
    bucket_reader = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ListObjectsInBucket"
          Action = [
            "s3:ListBucket",
          ]
          Effect   = "Allow"
          Resource = [var.bucket.arn]
        },
        {
          Sid = "ReadObjectActions"
          Action = [
            "s3:GetObject",
            "s3:GetObject*",
          ]
          Effect   = "Allow"
          Resource = ["${var.bucket.arn}/*"]
        },
      ]
    })

    bucket_writer = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ListObjectsInBucket"
          Action = [
            "s3:ListBucket",
          ]
          Effect   = "Allow"
          Resource = [var.bucket.arn]
        },
        {
          Sid = "AllObjectActions"
          Action = [
            "s3:*Object",
          ]
          Effect   = "Allow"
          Resource = ["${var.bucket.arn}/*"]
        },
      ]
    })

    log_reader = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ReadNamespaceLogs"
          Action = [
            "logs:Describe*",
            "logs:Get*",
            "logs:StartQuery",
            "logs:StopQuery",
            "logs:FilterLogEvents",
          ]
          Effect   = "Allow"
          Resource = "*"
          Condition = {
            StringLike = {
              "aws:ResourceTag/Namespace" = var.namespace_id
            }
          }
        },
      ]
    })

    log_writer = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "WriteNamespaceLogs"
          Action = [
            "logs:*",
          ]
          Effect   = "Allow"
          Resource = "*"
          Condition = {
            StringLike = {
              "aws:ResourceTag/Namespace" = var.namespace_id
            }
          }
        },
      ]
    })
  }
}

resource "aws_iam_policy" "this" {
  for_each = local.policies

  name = "${local.prefix}${each.key}"
  path = local.path

  policy = each.value
}

