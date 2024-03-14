output "list" {
  value = { for k, v in aws_ec2_managed_prefix_list.this : k => {
    arn = v.arn
    id  = v.id
  } }
}
