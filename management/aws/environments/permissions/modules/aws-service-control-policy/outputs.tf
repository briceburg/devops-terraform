output "arn" {
  value = aws_organizations_policy.scp.arn
}

output "attachments" {
  value = keys(aws_organizations_policy_attachment.scp)
}

output "id" {
  value = aws_organizations_policy.scp.id
}
