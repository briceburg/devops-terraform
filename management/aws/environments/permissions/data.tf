data "aws_s3_object" "org_data" {
  # org_data produced by management/aws/accounts terraform
  bucket = module.discovery.lookup_results[0].data.bucket
  key    = module.discovery.lookup_results[0].data.key
}

data "aws_ssoadmin_instances" "this" {}
