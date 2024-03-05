terraform {
  backend "s3" {
    bucket         = "iceburg-devops-tfstate-prod"
    dynamodb_table = "iceburg-devops-tfstate-prod-locks"
    encrypt        = true
    key            = "security/aws-oidc/github-actions/terraform.tfstate"
    profile        = "prod-shared-services/operate"
    region         = "us-east-2"
  }
}

