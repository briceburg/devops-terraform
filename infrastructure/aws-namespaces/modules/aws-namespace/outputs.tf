output "acm" {
  value = module.acm
}

output "bucket" {
  value = module.bucket
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}

output "ecr" {
  value = module.ecr
}

output "ecs" {
  value = module.ecs
}

output "iam" {
  value = module.iam
}

output "id" {
  value = terraform_data.namespace_id_is_ready.output
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "lambda" {
  value = module.lambda
}

output "lb" {
  value = module.lb
}

output "log_group" {
  value = aws_cloudwatch_log_group.this.name
}

output "log_region" {
  value = data.aws_region.current.name
}

output "network" {
  value = local.network
}

output "route53" {
  value = module.route53
}

output "sg" {
  value = module.sg
}

output "stage" {
  value = var.stage
}

