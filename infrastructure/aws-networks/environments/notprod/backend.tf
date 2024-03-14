terraform {
  backend "s3" {
    bucket         = "devops-terraform-tfstate-notprod"
    dynamodb_table = "devops-terraform-tfstate-notprod-locks"
    encrypt        = true
    key            = "infrastructure/aws-networks/notprod/terraform.tfstate"
    profile        = "notprod-shared-services/operate"
    region         = "us-east-2"
  }
}

