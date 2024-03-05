module "sg" {
  source = "./modules/sg"

  namespace_id = var.id
  stage        = var.stage
  vpc_cidr     = local.network.cidr
  vpc_id       = local.network.vpc_id
}

module "route53" {
  source = "./modules/route53"

  namespace_id = var.id
  stage        = var.stage
  vpc_id       = local.network.vpc_id

  providers = {
    aws     = aws
    aws.dns = aws.dns
    aws.ram = aws.ram
  }
}

module "acm" {
  source = "./modules/acm"

  namespace_id = var.id
  route53      = module.route53
  stage        = var.stage
}

module "ecr" {
  source = "./modules/ecr"

  kms_key_arn  = aws_kms_key.this.arn
  namespace_id = var.id
  stage        = var.stage
}

module "ecs" {
  source = "./modules/ecs"

  default_environment = local.default_environment
  iam                 = module.iam
  namespace_id        = var.id
  stage               = var.stage
}

module "bucket" {
  source = "./modules/bucket"

  namespace_id = var.id
  stage        = var.stage
}

module "iam" {
  source = "./modules/iam"

  bucket       = module.bucket
  namespace_id = var.id
  stage        = var.stage
}

module "lambda" {
  source = "./modules/lambda"

  namespace_id = var.id
  sg           = module.sg
  vpc          = local.network
  functions    = var.lambda_functions
}

module "lb" {
  for_each = toset(var.load_balancers)
  source   = "./modules/lb"

  acm          = module.acm
  bucket       = module.bucket
  id           = each.key
  namespace_id = var.id
  route53      = module.route53
  sg           = module.sg
  ssl_policy   = var.ssl_policy
  stage        = var.stage
  subnets      = local.network.subnets
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "namespace-${var.id}"
  retention_in_days = var.stage == "PRODUCTION" ? 365 : 7

  tags = {
    Namespace = var.id
    Stage     = var.stage
  }
}

resource "aws_db_subnet_group" "this" {
  name        = "namespace-${var.id}"
  subnet_ids  = local.network.subnets.intra
  description = "Default subnet group for RDS instances in the ${var.id} namespace."
  tags = {
    Namespace = var.id
    Name      = "namespace-${var.id}"
    Stage     = var.stage
  }
}

resource "aws_kms_key" "this" {
  description         = "Default crypto key for resources in the ${var.id} namespace."
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  tags = {
    Namespace = var.id
    Name      = "namespace-${var.id}"
    Stage     = var.stage
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/namespace-${var.id}"
  target_key_id = aws_kms_key.this.key_id
}
