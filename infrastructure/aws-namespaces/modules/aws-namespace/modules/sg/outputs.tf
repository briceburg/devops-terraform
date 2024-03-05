output "default" {
  value = aws_security_group.default.id
}

output "public" {
  value = aws_security_group.public.id
}

output "trusted" {
  value = aws_security_group.trusted.id
}
