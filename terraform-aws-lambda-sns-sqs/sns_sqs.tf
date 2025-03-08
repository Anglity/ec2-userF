resource "aws_sns_topic" "mi_sns_topic" {
  name = "mi_sns_topic"
}

resource "aws_sqs_queue" "mi_sqs_queue" {
  name = "mi_sqs_queue"
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.mi_sqs_queue.id
  policy    = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "sqs:SendMessage",
      Resource  = aws_sqs_queue.mi_sqs_queue.arn,
      Condition = {
        ArnEquals = {
          "aws:SourceArn" = aws_sns_topic.mi_sns_topic.arn
        }
      }
    }]
  })
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn            = aws_sns_topic.mi_sns_topic.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.mi_sqs_queue.arn
  raw_message_delivery = true
}
