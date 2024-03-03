output "functions" {
  value = { for k, v in aws_lambda_function.this : k => v.arn }
}

output "role" {
  value = aws_iam_role.this.arn
}

output "sg" {
  value = aws_security_group.this.id
}
