locals {
  default_environment = { # default environment variables for lambdas, ECS tasks, &c.
    NAMESPACE_ID = var.id
    #NAMESPACE_META  = jsonencode({})
    NAMESPACE_STAGE = var.stage
  }
  network = module.network_discovery.lookup_results[0]
}

