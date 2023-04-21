#Provider version
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
    datadog = {
      source = "datadog/datadog"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
