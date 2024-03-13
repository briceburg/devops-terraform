terraform {
  backend "s3" {
    bucket         = "devops-terraform-tfstate-management"
    dynamodb_table = "devops-terraform-tfstate-management-locks"
    encrypt        = true
    key            = "management/aws/users-and-groups/terraform.tfstate"
    profile        = "aws-org-management/operate"
    region         = "us-east-2"
  }
}
