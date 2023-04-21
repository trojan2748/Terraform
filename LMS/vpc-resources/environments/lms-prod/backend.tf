# S3 remote state

terraform {
  backend "s3" {
    bucket = "tf-remote-lms-prod-bkt"
    key    = "project/lms-prod/vpc"
    region = "us-east-1"
    dynamodb_table = "lms-prod-terraform-state"
  }
}
