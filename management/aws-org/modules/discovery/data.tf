data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition     = can(self.tags["Org"])
      error_message = "default_tags missing 'org' tag"
    }

    postcondition {
      condition     = can(self.tags["Application"])
      error_message = "default_tags missing 'application' tag"
    }
  }
}
