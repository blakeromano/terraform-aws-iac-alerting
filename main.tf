provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  count = var.create_trail ? 1 : 0
  bucket_prefix = "iac-cloudtrail-logs-${var.region}"
}

resource "aws_cloudtrail" "iac_trail" {
  count = var.create_trail ? 1 : 0
  name                          = "iac-trail"
  s3_bucket_name                = length(aws_s3_bucket.cloudtrail_logs) > 0 ? aws_s3_bucket.cloudtrail_logs[0].id : null
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }
}

resource "aws_sns_topic" "aws_iac_alerting_sns" {
  name         = "aws-iac-alerting-sns"
  display_name = "AWS IaC Alerting SNS"
  provider = aws
}

resource "aws_sns_topic_policy" "aws_iac_alerting_sns_policy" {
  arn    = aws_sns_topic.aws_iac_alerting_sns.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.aws_iac_alerting_sns.arn}"
    }
  ]
}
EOF
  provider = aws
}

resource "aws_iam_role" "manual_resource_alerts_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "chatbot.amazonaws.com",
          "events.amazonaws.com"
        ]
      }
    }
  ]
}
EOF
  provider = aws
}

resource "aws_iam_role_policy" "manual_resource_alerts_policy" {
  role = aws_iam_role.manual_resource_alerts_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["sns:*"],
      "Resource": "${aws_sns_topic.aws_iac_alerting_sns.arn}"
    }
  ]
}
EOF
  provider = aws
}

resource "aws_chatbot_slack_channel_configuration" "manual_resource_alerts" {
  configuration_name = "aws-iac-alerts"
  slack_channel_id   = var.slack_channel_id
  slack_team_id =  var.slack_team_id
  iam_role_arn       = aws_iam_role.manual_resource_alerts_role.arn
  sns_topic_arns     = [aws_sns_topic.aws_iac_alerting_sns.arn]
  provider = aws
}

resource "aws_cloudwatch_event_rule" "aws_iac_alerting_audit" {
  description  = "Alerting on changes to Infrastructure as Code resources outside of IaC"
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail" : {
      "eventSource" : [{
        "anything-but" : {
          "equals-ignore-case" : ["cloudshell.amazonaws.com"]
        }
      }],
      "userIdentity" : {
        "type" : ["AssumedRole","FederatedUser"],
        "principalId" : [{ "wildcard" : "*@gmail.com" }]
      },
      "eventName" : [{ "prefix" : "Create" }, { "prefix" : "Update" }, { "prefix" : "Put" }]
    }
  })
  provider = aws
}

resource "aws_cloudwatch_event_target" "aws_iac_alerting_audit_target" {
  rule      = aws_cloudwatch_event_rule.aws_iac_alerting_audit.name
  arn       = aws_sns_topic.aws_iac_alerting_sns.arn
  role_arn  = aws_iam_role.manual_resource_alerts_role.arn
  target_id = "aws-iac-alerts"
  provider = aws
}