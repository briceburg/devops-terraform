output "users" {
  value = { for k, v in aws_identitystore_user.this : k => v.user_id }
}

output "groups" {
  value = { for k, v in aws_identitystore_group.this : k => v.group_id }
}


