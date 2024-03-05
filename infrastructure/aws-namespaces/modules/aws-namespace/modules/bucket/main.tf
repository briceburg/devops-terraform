module "bucket" {
  source = "github.com/briceburg/devops-terraform-modules//aws-bucket" # TODO: use relative paths

  stage          = var.stage
  identifier     = "namespace-${var.namespace_id}"
  kms_encryption = false # TODO: lets try to allow customer managed KMS encryption on the bucket. it may involve granting access data.aws_elb_service_account.main.arn access to the namespace KMS key?
  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = module.bucket.name
  policy = data.aws_iam_policy_document.bucket.json
}

data "aws_elb_service_account" "main" {}
data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "AllowAccessLogsWrite"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.bucket.arn}/lb-access-logs/*"]
  }

  statement {
    sid = "AllowLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.bucket.arn}/*"]
  }

  statement {
    sid = "AllowLogDeliveryInspect"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [module.bucket.arn]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = module.bucket.name

  rule {
    id     = "lb-access-logs"
    status = "Enabled"

    filter {
      prefix = "lb-access-logs/*"
    }

    transition {
      days          = 0
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = var.stage == "PRODUCTION" ? 365 : 30
    }
  }
}

