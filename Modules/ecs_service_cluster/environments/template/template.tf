###########################
# S3 remote state backend #
###########################
terraform {
    backend "s3" {
        bucket = "gd-tf-backend"
        key    = "project/gs/gs-ecs_service_cluster"
        region = "us-east-1"
    }
}


data "terraform_remote_state" "network" {
    backend = "s3"

    config = {
        bucket         = "gd-tf-backend"
        key            = "project/gs/gs-network"
        region         = "us-east-1"
        dynamodb_table = "cwqa-terraform-state"
        kms_key_id     = "cwqa-terraform-state-kms"
    }
}

module "ecs_service_cluster" {
    env                             = "gs"
    source                          = "../../"
    aws_region                      = "us-east-1"
    vpc_cidr                        = "10.1.0.0/16"
    az_count                        = 4
    ecs_service-min_size            = 2
    ecs_service-max_size            = 3
    ecs_service-desired_capacity    = 2
}



output "ecs_cluster_id" {
    description = ""
    value       = module.ecs_service_cluster.ecs_cluster_id
}

output "ecs_agent_role_arn" {
    description = ""
    value       = module.ecs_service_cluster.ecs_agent_role_arn
}

output "vpc_sg_arn" {
    description = ""
    value       = module.ecs_service_cluster.vpc_sg_arn
}

output "vpc_public_subnets" {
    description = ""
    value       = module.ecs_service_cluster.vpc_public_subnets
}

output "vpc_private_subnets" {
    description = ""
    value       = module.ecs_service_cluster.vpc_private_subnets
}

output "vpc_gateway_arn" {
    description = ""
    value       = module.ecs_service_cluster.vpc_gateway_arn
}

output "vpc_gateway_ip" {
    description = ""
    value       = module.ecs_service_cluster.vpc_gateway_ip
}

