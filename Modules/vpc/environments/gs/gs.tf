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
module "vpc" {
    env                         = "gs"
    aws_region                  = "us-east-1"
    vpc_cidr                    = "10.100.0.0/16"
    vpc_private_subnets_count   = 4
    vpc_public_subnets_count    = 1
    vpc_enable_gateway          = false
    vpc_enable_classiclink      = false
    vpc_enable_dns_hostnames    = true
    vpc_dns_support             = true

    source                      = "../.."
    
}

###########
# Outputs #
###########
output "vpc_id" {
    description = "Main VPC"
    value       = module.vpc.vpc_id
}

#output "aws_private_subnet" {
#    description = "A list of cluster private subnets and their attributes"
#    value       = module.vpc.outputs.ecs_private_subnets
#}

