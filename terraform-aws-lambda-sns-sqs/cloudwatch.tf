# SNS para Alarmas de CloudWatch
resource "aws_sns_topic" "cw_alarm_topic" {
  name = "cloudwatch_alarm_topic"
}

resource "aws_sns_topic_subscription" "cw_alarm_email_subscription" {
  topic_arn = aws_sns_topic.cw_alarm_topic.arn
  protocol  = "email"
  endpoint  = "colang153@gmail.com"
}

# Alarma para errores en la función Lambda
resource "aws_cloudwatch_metric_alarm" "lambda_errors_alarm" {
  alarm_name          = "LambdaErrorsAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarma cuando la función Lambda tenga errores."
  dimensions = {
    FunctionName = aws_lambda_function.mi_lambda.function_name
  }
  alarm_actions = [aws_sns_topic.cw_alarm_topic.arn]
}

# Alarma para la longitud de la cola SQS (mensajes visibles)
resource "aws_cloudwatch_metric_alarm" "sqs_queue_length_alarm" {
  alarm_name          = "SQSQueueLengthAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 10  # Ajusta este umbral según tus necesidades
  alarm_description   = "Alarma cuando la longitud de la cola SQS supera el umbral."
  dimensions = {
    QueueName = aws_sqs_queue.mi_sqs_queue.name
  }
  alarm_actions = [aws_sns_topic.cw_alarm_topic.arn]
}
