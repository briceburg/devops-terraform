resource "aws_ecs_cluster" "this" {
  name = "namespace-${var.namespace_id}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = var.stage == "PRODUCTION" ? "FARGATE" : "FARGATE_SPOT"
  }
}
