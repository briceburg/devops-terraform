terraform {
  backend "s3" {
    bucket         = "iceburg-devops-tfstate-prod"
    dynamodb_table = "iceburg-devops-tfstate-prod-locks"
    encrypt        = true
    key            = "infrastructure/aws-dns/prod/terraform.tfstate"
    profile        = "prod-shared-services/operate"
    region         = "us-east-2"
  }
}

