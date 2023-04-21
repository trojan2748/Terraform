terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-dev-bkt"
    key            = "project/lms-dev/postgresql"
    region         = "us-east-1"
    dynamodb_table = "lms-terraform-state"

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

