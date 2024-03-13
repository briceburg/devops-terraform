terraform {
  backend "s3" {
    bucket         = "devops-terraform-tfstate-management"       # use bucket_id output from environments/management terraform
    dynamodb_table = "devops-terraform-tfstate-management-locks" # use lock_table_id output from environments/management terraform 
    encrypt        = true
    key            = "management/tfstate/project-state/terraform.tfstate"
    profile        = "aws-org-management/operate"
    region         = "us-east-2"
  }
}


