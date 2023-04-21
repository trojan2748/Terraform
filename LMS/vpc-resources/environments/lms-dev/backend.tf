# S3 remote state

terraform {
  backend "s3" {
    bucket = "tf-remote-lms-dev-bkt"
    key    = "project/lms-dev/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-terraform-state"
  }
}

