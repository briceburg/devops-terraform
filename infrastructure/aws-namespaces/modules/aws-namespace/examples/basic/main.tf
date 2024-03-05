terraform {
  backend "s3" {
    bucket         = "iceburg-devops-tfstate-notprod"
    dynamodb_table = "iceburg-devops-tfstate-notprod-locks"
    encrypt        = true
    key            = "terraform-modules/aws-namespace/examples/basic/terraform.tfstate"
    profile        = "notprod-shared-services/operate"
    region         = "us-east-2"
  }
}

locals {
  application = "aws-namespace"
  environment = terraform.workspace
}

module "namespace" {
  source = "../../"
  # load_balancers  = ["trusted"]
  # network_type    = "unique"
  # network_routing = "self"

  providers = {
    aws     = aws
    aws.dns = aws.network
    aws.ram = aws.network
  }
}

output "main" {
  value = module.namespace
}
