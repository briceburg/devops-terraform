resource "aws_identitystore_group" "this" {
  display_name      = var.name
  description       = var.description
  identity_store_id = var.identity_store_id
}
