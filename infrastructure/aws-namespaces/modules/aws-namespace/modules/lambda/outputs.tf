output "iam_role" {
  value = aws_iam_role.this.arn
}

output "functions" {
  value = { for k, v in aws_lambda_function.this : k => v.arn }
}
