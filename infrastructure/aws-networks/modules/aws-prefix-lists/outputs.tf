output "arns" {
  value = [for p in aws_ec2_managed_prefix_list.this : p.arn]
}
