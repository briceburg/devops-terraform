output "bucket" {
  value = aws_s3_object.data.bucket
}

output "key" {
  value = aws_s3_object.data.key
}

output "url" {
  value = "s3://${aws_s3_object.data.bucket}/${aws_s3_object.data.key}"
}
