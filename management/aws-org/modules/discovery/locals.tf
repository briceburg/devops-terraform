locals {
  bucket_name = lower("${local.tags.org}-${local.tags.application}")
  tags        = { for k, v in data.aws_default_tags.this.tags : lower(k) => v }
}
