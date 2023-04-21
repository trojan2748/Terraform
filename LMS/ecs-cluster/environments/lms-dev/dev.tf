data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tf-remote-lms-dev-bkt"
    key    = "project/lms-dev/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-terraform-state"

  }
}


locals {

  application = "ecs-lms"
  environment = "lms-dev"
  aws_account = "lms-dev"

}

module "ecs_cluster" {
  source = "../../"

  ########################
  # Common
  ########################

  environment = local.environment
  application = local.application
  aws_account = local.aws_account
  platform    = "LMS"
  env         = "dev"


  ########################
  # Cluster
  ########################

  cluster_name = "${local.environment}-cluster"
  ami_id       = "ami-0dfda8a3ee7678578"
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id

  ########################
  # Capacity provider
  ########################

  managed_scaling_max_step_size   = 2
  managed_scaling_mix_step_size   = 1
  managed_scaling_target_capacity = 90

  ########################
  # Launch template
  ########################

  instance_type = "t3.large"

  ########################
  # Autoscaling group
  ########################

  availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  asg_desired_capacity   = 3
  asg_max_size           = 15
  asg_min_size           = 3
  override_instance_type = "t3.medium"
  override_weight        = 3
  vpc_zone_identifier    = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*].id
  autoscaling_group_name = "${local.environment}-ASG"
  security_groups        = [ data.terraform_remote_state.vpc.outputs.alb_security_group_output.id ]
  vpc_security_group_ids = [ data.terraform_remote_state.vpc.outputs.asg_security_group_output.id ]


  ########################
  # Load Balancer
  ########################

  lb_name                       = "${local.environment}-service-private-alb"
  lb_subnets                    = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*].id
  lb_enable_deletion_protection = false

   ################################
  #Tag
  ################################
  /*
  lms_lb_ingress_rules = [
  
    {
      description = "gl-InfraServices ClientVPN Users"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "192.168.128.0/19"  
    },
    {
      description = "DC6 - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.249.0.0/20"
    }
  ]

  lms_lb_egress_rules = [
  
    {
      description = "Allow all outgoing traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  lms_asg_ingress_rules = [
  
    {
      description = "gl-InfraServices ClientVPN Users"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "192.168.128.0/19"
    },
    {
      description = "DC6 - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.249.0.0/20"
    }
  ]

  lms_asg_egress_rules = [
  
    {
      description = "Allow all outgoing traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
  ]
  
  */
  
  ######################
  # Route 53
  ######################

  create_hosted_zone = true
  hosted_zone_name   = "dev.lms.glidewell.com"

}

output "aws_lb" {
  description = "ALB 1"
  value       = module.ecs_cluster.aws_lb
}

# output "aws_lb" {
#   description = "ALB 1"
#   value       = module.ecs_cluster.aws_lb
# }
