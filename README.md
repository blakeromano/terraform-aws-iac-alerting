# terraform-aws-iac-alerting

This Terraform module configures AWS monitoring and alerting components so you can quickly set up alarms for when people are manually updating resources and not using IaC.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
- [Notes](#notes)

## Requirements

- Terraform ≥ 0.13
- AWS provider

## Usage

```hcl
module "iac_alerting" {
  source = "git::https://github.com/blakeromano/terraform-aws-iac-alerting.git"

  enabled = true
  alert_topic_name = "critical-alerts"
  region           = "us-east-1"
  slack_team_id    = "TXXXXXXX"
  slack_channel_id = "CXXXXXXX"
}
```

## Inputs

| Name             | Description                                                  | Type  | Default     | Required |
|------------------|--------------------------------------------------------------|-------|------------|:--------:|
| enabled          | Enable or disable alerting                                   | bool  | true       |    no    |
| alert_topic_name | SNS topic name for critical alerts                          | string| ""         |   yes    |
| region           | The AWS region to deploy resources in                       | string| "us-east-1"|    no    |
| slack_team_id    | The ID of the Slack workspace for notifications             | string| n/a        |   yes    |
| slack_channel_id | The ID of the Slack channel for notifications               | string| n/a        |   yes    |
| create_trail     | Flag to create a CloudTrail for monitoring AWS API calls    | bool  | true       |    no    |

| Name                    | Description                                           |
|-------------------------|-------------------------------------------------------|
| alerting_sns_topic_arn  | ARN of the SNS topic for forwarding critical alerts   |

## Examples

For a complete example, check out the [examples](examples/basic) directory.

## Notes

- Ensure your AWS credentials have the necessary permissions to create the required resources
- Authenticate the workspace with AWS Q Chatbot before running TF apply