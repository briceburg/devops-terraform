locals {
  config = {
    public = {
      type = "application"
      sgs  = [var.sg.default, var.sg.trusted, var.sg.public]
    }
    trusted = {
      type = "application"
      sgs  = [var.sg.default, var.sg.trusted]
    }
    nlb = {
      type = "network"
      sgs  = null
    }
  }

  is_application = local.config[var.id].type == "application"
}

resource "aws_lb" "this" {
  name_prefix                      = substr(var.id, 0, 6)
  internal                         = false
  load_balancer_type               = local.config[var.id].type
  security_groups                  = local.config[var.id].sgs
  subnets                          = var.subnets.public
  enable_cross_zone_load_balancing = true
  enable_waf_fail_open             = false
  enable_http2                     = true
  preserve_host_header             = false # rely on X-Forwarded-For 

  dynamic "access_logs" {
    for_each = local.is_application ? [1] : []
    content {
      bucket  = var.bucket.name
      prefix  = "lb-access-logs/${var.id}"
      enabled = true
    }
  }

  tags = {
    Namespace = var.namespace_id
    Name      = "namespace-${var.namespace_id}-${var.id}"
    Stage     = var.stage
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.route53.zone_id
  name    = var.id

  type = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true
}

#
# load balancer listeners
# the idea is to have common listeners (port 80 and port 443) on the ALBs 
# to support sharing service deploys by using rules against their hostnames/paths.
# 
# add downstream lb_listener_rule and lb_listener_certificate resources to extend.
#

resource "aws_lb_listener" "http" {
  count             = local.is_application ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = local.is_application ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "no matching path or hostname"
      status_code  = "410"
    }
  }
}
