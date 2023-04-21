#terraform {
#    backend "s3" {
#        bucket = "gd-tf-backend"
#        key    = "project/tempate/TEMPLATE-network"
#        region = "us-east-1"
#    }
#}


# Create w/ TF but removed from state after
resource "aws_s3_bucket" "b" {
    bucket = "gd-TEMPLATE-backend"
}

module "ecsanywhere" {
    env     = "TEMPLATE"
    source  = "../.."
}
