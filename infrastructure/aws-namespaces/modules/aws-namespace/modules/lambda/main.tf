#TODO: Use an aws-namespace-lambda module instead

data "archive_file" "zip" {
  for_each = toset(var.functions)

  type        = "zip"
  source_dir  = "${path.module}/src/${each.key}"
  output_path = "${path.module}/src/${each.key}.zip"
}

resource "aws_lambda_function" "this" {
  for_each = toset(var.functions)

  function_name    = "namespace-${var.namespace_id}-${each.key}"
  filename         = data.archive_file.zip[each.key].output_path
  source_code_hash = data.archive_file.zip[each.key].output_base64sha256
  role             = aws_iam_role.this.arn
  runtime          = "python3.9"
  handler          = "main.lambda_handler"
  vpc_config {
    security_group_ids = [var.sg.default]
    subnet_ids         = var.vpc.subnets.private
  }
}



