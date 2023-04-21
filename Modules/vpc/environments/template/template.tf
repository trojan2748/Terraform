#
# NOTE: Replace TEMPLATE with your own env
#

###########################
# S3 remote state backend #
###########################
terraform {
    backend "s3" {
        bucket = "tf-remote-bkt3"
        key    = "project/TEMPLATE/TEMPLATE-network"
        region = "us-east-1"
    }
}

#########################
# Environment variables #
#########################
module "network" {
    env         = "TEMPLATE"
    aws_region  = "us-east-1"
    source      = "../.."
}
