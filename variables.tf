variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "slack_team_id" {
  description = "The ID of the Slack workspace for notifications"
  type        = string
}

variable "slack_channel_id" {
  description = "The ID of the Slack channel for notifications"
  type        = string
}

variable "create_trail" {
  description = "Flag to create a CloudTrail for monitoring AWS API calls"
  type = bool
  default = true
}