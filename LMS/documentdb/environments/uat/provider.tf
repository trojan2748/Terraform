terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-uat-bkt"
    key            = "project/lms-uat/documentdb"
    region         = "us-east-1"
    dynamodb_table = "lms-uat-terraform-state"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}


/*

data "aws_ssm_parameter" "datadog_api_key" {
  name = "/${local.aws_account}/terraform/datadog/datadog_api_key"
}

data "aws_ssm_parameter" "datadog_app_key" {
  name = "/${local.aws_account}/terraform/datadog/datadog_app_key"
}

# Configure the Datadog provider
provider "datadog" {
  api_key = data.aws_ssm_parameter.datadog_api_key.value
  app_key = data.aws_ssm_parameter.datadog_app_key.value
}

*/