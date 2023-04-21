# S3 remote state

terraform {
  backend "s3" {
    bucket = "tf-remote-lms-qa-bkt"
    key    = "project/lms-qa/vpc"
    region = "us-east-1"
    dynamodb_table = "lms-qa-terraform-state"
  }
}
