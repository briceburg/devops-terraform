
resource "aws_organizations_policy" "scp" {
  content = var.policy_content
  name    = var.policy_name
  type    = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "scp" {
  for_each = toset(var.ou_paths)

  policy_id = aws_organizations_policy.scp.id
  target_id = var.org_data.ou_paths[each.key]
}

