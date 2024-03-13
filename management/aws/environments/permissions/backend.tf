terraform {
  backend "s3" {
    bucket         = "devops-terraform-tfstate-management"
    dynamodb_table = "devops-terraform-tfstate-management-locks"
    encrypt        = true
    key            = "management/aws/permissions/terraform.tfstate"
    profile        = "aws-org-management/operate"
    region         = "us-east-2"
  }
}
