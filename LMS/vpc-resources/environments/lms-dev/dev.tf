# Dev VPC for LMS

module "vpc" {
  source                = "../../"
  vpc_cidr              = "10.249.128.0/20"
  public_subnets_cidr   = ["10.249.140.0/24", "10.249.141.0/24", "10.249.142.0/24", "10.249.143.0/24"]
  private_subnets_cidr  = ["10.249.128.0/24", "10.249.129.0/24", "10.249.130.0/24", "10.249.131.0/24"]
  database_subnets_cidr = ["10.249.136.0/24", "10.249.137.0/24", "10.249.138.0/24", "10.249.139.0/24"]
  create                = true
  azs                   = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  stage                 = "LMS"
  namespace             = "lms-dev"
  transit_gateway_id    = "tgw-057b71703ad14eced"
  transit_gateway_path  = "Dev/LMSDEV"


  alb_sg_ingress_rules = [
    
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
      cidr_block  = "12.1.209.224/28"
    }
  ]

  asg_sg_ingress_rules = [
    
    {
      description = "DC6 - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "12.1.209.224/28"
    },
    {
      description = "gl-InfraServices ClientVPN Users"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "192.168.128.0/19"
    },
  
    {
      description = "Workspaces - NATGWY"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "100.21.192.90/32"
    }
  ]

  elasticsearch_sg_ingress_rules = [

    {
      description = "(VPC) dev - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.196.0.0/16"
    }
  ]
}


output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The ID of the VPC"
  value       = module.vpc.public_subnets_ids
}

output "private_subnet_ids" {
  description = "The ID of the VPC"
  value       = module.vpc.private_subnets_ids
}

output "database_subnets_ids" {
  description = "All public subnets."
  value       = module.vpc.database_subnets_ids
}

output "alb_security_group_output" {
  description = "Security group for the application load balancer."
  value       = module.vpc.asg_security_group_output
}

output "asg_security_group_output" {
  description = "Security group for the autoscaling group."
  value       = module.vpc.asg_security_group_output
}

output "elastisearch_security_group_output" {
  description = "Security group for the elasticsearch group."
  value       = module.vpc.elasticsearch_security_group_output
}
