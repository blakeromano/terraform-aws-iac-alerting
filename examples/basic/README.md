# Basic Example for terraform-aws-iac-alerting

This example demonstrates how to use the `terraform-aws-iac-alerting` module to set up AWS monitoring and alerting for manual resource changes.

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Prerequisites

- AWS credentials configured
- A Slack workspace and channel where you want to receive alerts
- AWS Chatbot configured with your Slack workspace

## Notes

- Replace the placeholder Slack IDs with your actual IDs
- Ensure your AWS credentials have the necessary permissions to create the required resources
- Authenticate the workspace with AWS Q Chatbot before running TF apply