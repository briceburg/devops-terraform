resource "aws_iam_role" "task-role" {
  name                  = "${var.namespace_id}-ecs-task-role"
  description           = "a default role for containers to run under. attach policies to grant permissions."
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "TerraformManaged"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "AllowECSExec"
          Action = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid = "ReadRegionalSecrets"
          Action = [
            "secretsmanager:GetSecretValue"
          ]
          Effect   = "Allow"
          Resource = "arn:${data.aws_partition.current.partition}:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*/*"
        },
      ]
    })
  }

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}


resource "aws_iam_role_policy_attachment" "task-role" {
  for_each = {
    read_objects = var.iam.policies.bucket_reader.arn # allow tasks to read S3 bucket objects within the namespace
    read_logs    = var.iam.policies.log_reader.arn    # allow tasks to read cloudwatch logs within the namespace
  }

  role       = aws_iam_role.task-role.name
  policy_arn = each.value
}


resource "aws_iam_role" "execution-role" {
  name                  = "${var.namespace_id}-ecs-execution-role"
  description           = "allow for pulling from ECR and shipping logs to cloudwatch"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "TerraformManaged"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ReadRegionalSecrets"
          Action = [
            "secretsmanager:GetSecretValue"
          ]
          Effect   = "Allow"
          Resource = "arn:${data.aws_partition.current.partition}:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"
        }
      ]
    })
  }

  tags = {
    Namespace = var.namespace_id
    Stage     = var.stage
  }
}

resource "aws_iam_role_policy_attachment" "execution-role" {
  role       = aws_iam_role.execution-role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
