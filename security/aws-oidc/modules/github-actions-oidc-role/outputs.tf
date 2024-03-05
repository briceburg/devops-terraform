output "role_arn" {
  value = aws_iam_role.github.arn
}

output "role_name" {
  value = aws_iam_role.github.name
}

output "subject_claims" {
  value = var.subject_claims
}
