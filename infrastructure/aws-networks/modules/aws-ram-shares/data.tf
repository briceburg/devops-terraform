data "aws_s3_object" "ou_paths" {
  # ou_paths.json produced by the management/aws-org account terraform
  bucket = "${var.organization_name}-aws-org"
  key    = "ou_paths.json"
}

data "aws_organizations_organization" "this" {}
data "aws_partition" "this" {}

locals {
  ou_paths = jsondecode(data.aws_s3_object.ou_paths.body)

  ram_share_ous = [
    # share with accounts in this organization belonging to the same tier
    split("/", local.ou_paths["${var.organization_name}.${var.tier}"])[2],
  ]

  # share VPCs, transit gateways, prefix lists, &c... 
  ram_share_prinicipal_arns = concat(
    [for ou in local.ram_share_ous : "arn:${data.aws_partition.this.id}:organizations::${data.aws_organizations_organization.this.master_account_id}:ou/${data.aws_organizations_organization.this.id}/${ou}"],
  )
}
