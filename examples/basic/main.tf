provider "aws" {
  region = "us-east-1"
}

module "iac_alerting" {
  source = "../../"

  region           = "us-east-1"
  slack_team_id    = "T1234567890"  # Replace with your actual Slack Team ID
  slack_channel_id = "C1234567890"  # Replace with your actual Slack Channel ID
}