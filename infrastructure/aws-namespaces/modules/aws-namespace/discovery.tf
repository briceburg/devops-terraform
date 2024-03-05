module "network_discovery" {
  source  = "github.com/briceburg/devops-terraform-modules//aws-discovery" # TODO: use relative paths
  lookups = ["networks/${var.network_id}"]

  providers = {
    aws = aws.ram
  }
}

module "discovery" {
  source = "github.com/briceburg/devops-terraform-modules//aws-discovery" # TODO: use relative paths
  registrations = {
    "namespaces/${var.id}" = {
      acm                  = module.acm
      bucket               = module.bucket
      db_subnet_group_name = aws_db_subnet_group.this.name
      ecr                  = module.ecr
      ecs                  = module.ecs
      iam                  = module.iam
      id                   = var.id
      kms_key_arn          = aws_kms_key.this.arn
      lambda               = module.lambda
      lb                   = module.lb
      log_group            = aws_cloudwatch_log_group.this.name
      log_region           = data.aws_region.current.name
      network              = local.network
      route53              = module.route53
      sg                   = module.sg
      stage                = var.stage
    }
  }
}

resource "terraform_data" "namespace_id_is_ready" {
  input = var.id

  # delay id output until discovery params are in place
  depends_on = [
    module.discovery,
  ]
}
