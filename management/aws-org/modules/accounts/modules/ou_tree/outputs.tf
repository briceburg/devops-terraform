output "map" {
  value = merge(
    {
      "." = {
        id   = var.root_id
        path = var.root_id
      }
    },
    { for k, v in aws_organizations_organizational_unit.level_0 : k => {
      id   = v.id
      path = "${var.root_id}/${v.id}"
    } },
    { for k, v in aws_organizations_organizational_unit.level_1 : k => {
      id   = v.id
      path = "${var.root_id}/${aws_organizations_organizational_unit.level_0[split(".", k)[0]].id}/${v.id}"
    } },
    { for k, v in aws_organizations_organizational_unit.level_2 : k => {
      id   = v.id
      path = "${var.root_id}/${aws_organizations_organizational_unit.level_0[split(".", k)[0]].id}/${aws_organizations_organizational_unit.level_1[regex("(.*)\\..*$", k)[0]].id}/${v.id}"
    } },
  )
}
