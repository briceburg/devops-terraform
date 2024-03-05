output "policies" {
  value = { for k, v in aws_iam_policy.this : k => {
    arn  = v.arn
    name = v.name
  } }
}

