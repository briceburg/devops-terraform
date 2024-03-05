output "cluster" {
  value = aws_ecs_cluster.this.id
}

output "default_task_environment" {
  description = "default ECS task environment configuration -- referenced by ecs-deployment module"
  value       = var.default_environment
}

output "execution_role_arn" {
  description = "the execution role allows pulling from ECR and shipping logs to cloudwatch"
  value       = aws_iam_role.execution-role.arn
}

output "execution_role_name" {
  value = aws_iam_role.execution-role.name
}

output "task_role_arn" {
  description = "the default role containers run under. attach policies to grant additional permissions."
  value       = aws_iam_role.task-role.arn
}

output "task_role_name" {
  value = aws_iam_role.task-role.name
}
