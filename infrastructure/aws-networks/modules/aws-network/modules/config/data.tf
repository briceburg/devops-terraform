data "aws_availability_zones" "prefered" {
  state = "available"
  exclude_zone_ids = [
    # exclude zones with known issue. it's OK to exclude zones from different regions...
    "use1-az3",
  ]
}
