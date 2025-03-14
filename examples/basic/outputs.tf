output "alerting_sns_topic_arn" {
  description = "The alerting SNS topic ARN"
  value       = module.iac_alerting.alerting_sns_topic_arn
}