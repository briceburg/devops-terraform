output "accounts" {
  value = var.accounts
}

output "accounts_url" {
  value = "s3://${aws_s3_object.accounts.bucket}/${aws_s3_object.accounts.key}"
}

output "ou_paths_url" {
  value = "s3://${aws_s3_object.ou_paths.bucket}/${aws_s3_object.ou_paths.key}"
}
