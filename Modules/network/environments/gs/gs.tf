###########################
# S3 remote state backend #
###########################
terraform {
    backend "s3" {
        bucket = "gd-tf-backend"
        key    = "project/gs/gs-network"
        region = "us-east-1"
    }
}


#########################
# Environment variables #
#########################
module "network" {
    env         = "gs"
    aws_region  = "us-east-1"
    source      = "../.."
}

###########
# Outputs #
###########
output "vpc_id" {
    description = "Main VPC"
    value       = module.network.vpc_id
}

output "aws_private_subnet" {
    description = "A list of cluster private subnets and their attributes"
    value       = module.network.ecs_private_subnets
}

