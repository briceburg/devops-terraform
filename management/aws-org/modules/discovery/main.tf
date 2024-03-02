resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_org_accounts" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_from_org_accounts.json
}

data "aws_iam_policy_document" "allow_access_from_org_accounts" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"] # be sure to limit allowed prinipals via a condition
    }

    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.organization_id]
    }
  }
}

resource "aws_s3_object" "accounts" {
  bucket       = aws_s3_bucket.this.bucket
  key          = "accounts.json"
  content      = jsonencode(var.accounts)
  content_type = "application/json"
}

resource "aws_s3_object" "ou_paths" {
  bucket       = aws_s3_bucket.this.bucket
  key          = "ou_paths.json"
  content      = jsonencode(var.ou_paths)
  content_type = "application/json"
}
