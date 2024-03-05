#
# apex zone for namespaces
#

# be sure to delegate the root domain's record to this zone's nameservers
resource "aws_route53_zone" "namespace_apex" {
  name          = "${var.tier}.${var.apex_zone_root_domain}"
  comment       = "apex zone for ${var.tier} namespaces"
  force_destroy = true
}

