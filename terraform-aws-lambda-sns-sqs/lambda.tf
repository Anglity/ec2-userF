resource "aws_lambda_function" "mi_lambda" {
  function_name = "mi_lambda_function"
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.id
  s3_key        = "ruta/al/codigo/mi_lambda.zip"  # Debe coincidir con la ruta en S3
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      SMTP_HOST = "smtp.example.com"  # Cambia al servidor SMTP que uses
      SMTP_PORT = "587"
      SMTP_USER = "usuario"
      SMTP_PASS = "contraseña"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  event_source_arn = aws_sqs_queue.mi_sqs_queue.arn
  function_name    = aws_lambda_function.mi_lambda.arn
  enabled          = true
  batch_size       = 10
}
