resource "aws_organizations_organizational_unit" "level_0" {
  for_each  = toset(var.level_0)
  name      = each.value
  parent_id = var.parent_id
}

resource "aws_organizations_organizational_unit" "level_1" {
  for_each  = { for p in local.level_1 : p.key => p }
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_0[each.value.parent].id
}

resource "aws_organizations_organizational_unit" "level_2" {
  for_each  = { for p in local.level_2 : p.key => p }
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_1[each.value.parent].id
}
