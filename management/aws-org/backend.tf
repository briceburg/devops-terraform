terraform {
  backend "s3" {
    bucket         = "iceburg-devops-tfstate-management"
    dynamodb_table = "iceburg-devops-tfstate-management-locks"
    encrypt        = true
    key            = "management/aws-org/terraform.tfstate"
    profile        = "iceburg-management/operate"
    region         = "us-east-2"
  }
}
