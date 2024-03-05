terraform {
  backend "s3" {
    bucket         = "iceburg-devops-tfstate-notprod"
    dynamodb_table = "iceburg-devops-tfstate-notprod-locks"
    encrypt        = true
    key            = "infrastructure/aws-namespaces/team-sky/terraform.tfstate"
    profile        = "notprod-shared-services/operate"
    region         = "us-east-2"
  }
}

