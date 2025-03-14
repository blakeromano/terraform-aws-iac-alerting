output "alerting_sns_topic_arn" {
  description = "The alerting SNS topic ARN"
  value       = aws_sns_topic.aws_iac_alerting_sns.arn
}