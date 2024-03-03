data "archive_file" "zip" {
  for_each = toset(var.functions)

  type        = "zip"
  source_dir  = "${path.module}/src/${each.key}"
  output_path = "${path.module}/src/${each.key}.zip"
}

resource "aws_lambda_function" "this" {
  for_each = toset(var.functions)

  function_name    = "${var.id}-${each.key}"
  filename         = data.archive_file.zip[each.key].output_path
  source_code_hash = data.archive_file.zip[each.key].output_base64sha256
  role             = aws_iam_role.this.arn
  runtime          = "python3.9"
  handler          = "main.lambda_handler"
  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = var.subnet_ids
  }
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.id}-lambda"
  description = "SG for ${var.id} lambdas."

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
    Name       = "${var.id}-lambda"
    Network_ID = var.id
  }
}


