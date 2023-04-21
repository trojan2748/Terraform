# S3 remote state

terraform {
  backend "s3" {
    bucket = "tf-remote-lms-uat-bkt"
    key    = "project/lms-uat/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-uat-terraform-state"
  }
}
