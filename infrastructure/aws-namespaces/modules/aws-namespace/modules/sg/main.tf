resource "aws_security_group" "default" {
  vpc_id      = var.vpc_id
  name_prefix = "namespace-${var.namespace_id}-default"
  description = "Default SG for ${var.namespace_id} Namespace resources."

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [description]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    description = "allow traffic between resources sharing this SG"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "allow outbound"
  }

  tags = {
    Name      = "namespace-${var.namespace_id}-default"
    Namespace = var.namespace_id
    Stage     = var.stage
    Tier      = "default"
  }
}

resource "aws_security_group" "public" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.namespace_id}-public"
  description = "Allow ingress from public WAN sources, e.g. specific IPs or from everywhere."

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [description]
  }

  tags = {
    Name      = "namespace-${var.namespace_id}-public"
    Namespace = var.namespace_id
    Stage     = var.stage
    Tier      = "public"
  }
}

resource "aws_security_group" "trusted" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.namespace_id}-trusted"
  description = "Allow ingress from the trusted WAN/Edge sources"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [description]
  }

  tags = {
    Name      = "namespace-${var.namespace_id}-trusted"
    Namespace = var.namespace_id
    Stage     = var.stage
    Tier      = "trusted"
  }
}

# TODO: this is too permissive. AFAIK it's needed for NLB healthchecks, as NLBs do not get assigned a SG. 
resource "aws_security_group_rule" "trusted_vpc_traffic" {
  cidr_blocks       = [var.vpc_cidr]
  from_port         = 0
  protocol          = "all"
  security_group_id = aws_security_group.trusted.id
  to_port           = 0
  type              = "ingress"
  description       = "Allow traffic from the VPC, e.g. from support ingress from NLB healthchecks. Terraform Managed."
}
