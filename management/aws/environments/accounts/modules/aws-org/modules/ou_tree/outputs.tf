output "paths" {
  # map keys are well-known at plan time to satisfy fresh for_each requirements
  value = merge(
    {
      "." = var.parent_id
    },
    { for k, v in aws_organizations_organizational_unit.level_0 : k => v.id },
    { for k, v in aws_organizations_organizational_unit.level_1 : k => v.id },
    { for k, v in aws_organizations_organizational_unit.level_2 : k => v.id },
  )
}

