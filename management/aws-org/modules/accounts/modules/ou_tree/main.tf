resource "aws_organizations_organizational_unit" "level_0" {
  for_each  = toset(var.level_0)
  name      = each.value
  parent_id = var.root_id

  tags = {
    Org = each.key
  }
}

resource "aws_organizations_organizational_unit" "level_1" {
  for_each  = { for p in local.level_1 : p.key => p }
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_0[each.value.parent].id

  tags = {
    Org = each.value.root
  }
}

resource "aws_organizations_organizational_unit" "level_2" {
  for_each  = { for p in local.level_2 : p.key => p }
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_1[each.value.parent].id

  tags = {
    Org  = each.value.root
    Tier = each.value.parent
  }
}
