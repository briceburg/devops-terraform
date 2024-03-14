locals {
  pl_map = merge(
    { for id, v in var.managed_list_map : "${id}-ipv4" => {
      id     = id
      family = "IPv4"
      entries = flatten([for desc, cidrs in v : [for cidr in cidrs : { cidr = cidr, desc = desc } if !can(regex(":", cidr))]]) }
    },
    { for id, v in var.managed_list_map : "${id}-ipv6" => {
      id     = id
      family = "IPv6"
      entries = flatten([for desc, cidrs in v : [for cidr in cidrs : { cidr = cidr, desc = desc } if can(regex(":", cidr))]]) }
    }
  )
}

resource "aws_ec2_managed_prefix_list" "this" {
  for_each       = { for k, v in local.pl_map : k => v if length(v.entries) > 0 }
  name           = each.key
  address_family = each.value.family
  max_entries    = length(each.value.entries) + 1 # + 1 to allow headspace / manual addition

  dynamic "entry" {
    for_each = each.value.entries
    content {
      cidr        = entry.value["cidr"]
      description = entry.value["desc"]
    }
  }
}

module "ram_share" {
  source   = "github.com/briceburg/devops-terraform-modules//aws-ram-share"
  for_each = toset(var.enable_sharing ? keys(var.managed_list_map) : [])


  name = "prefix-list-${each.key}"
  resources = merge(
    try({ "${each.key}-ipv4" = aws_ec2_managed_prefix_list.this["${each.key}-ipv4"].arn }, {}),
    try({ "${each.key}-ipv6" = aws_ec2_managed_prefix_list.this["${each.key}-ipv6"].arn }, {}),
  )
}
