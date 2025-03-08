resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "mi-lambda-code-bucket-unique-id"
}

resource "aws_s3_bucket_versioning" "lambda_versioning" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
