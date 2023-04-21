data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tf-remote-lms-uat-bkt"
    key    = "project/lms-uat/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-uat-terraform-state"
    
  }
}

locals {

  environment = "uat"
  domain      = "lms"
  region      = "east"
  aws_account = "lms-uat"
  
}

module "documentdb_cluster" {
  source = "../../"

  ########################
  # Security Group
  ########################

  ingress_cidr_blocks = ["10.196.0.0/16", "10.249.0.0/20", "192.168.128.0/19"]

  ########################
  # DocumentDB Cluster
  ########################

  port                            = 27017
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  preferred_backup_window         = "00:00-00:30"
  preferred_maintenance_window    = "sat:10:00-sat:10:30"
  storage_encrypted               = true
  skip_final_snapshot             = true
  subnet_ids                      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_id                          = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_security_group_ids          = [data.terraform_remote_state.vpc.outputs.asg_security_group_output.id]
  domain                          = local.domain
  db_subnet_group_name            = "lms-uat-subnet-group"
  instance_count                  = "2"
  instance_class                  = "db.t3.medium"
  lms-asg-sg                      = "sg-00fc551a4fefd8032"
  lms-alb-sg                      = "sg-038ff21b0f78f37c6"
  env                             = "lms-uat"
 
  ########################
  # DocumentDB Primary Instance
  ########################

  #######################
  # KMS
  ######################

  key_alias = "alias/${local.environment}-${local.region}-${local.domain}--marketing-docdb"

  ########################
  # Tags
  ########################

  environment      = local.environment
  resource_version = "0.0.1"

  docdb_sg_ingress_rules = [
  
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

  source_docdb_ingress_rules  = [
     
    {
       #description = "(Security Group) ep-prod - Autoscaling Group security group - All Traffic"
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       #source_security_group_id = var.ep-prod-asg-sg
    },
    {
      #description = "(Security Group)  ep-prod - Application Load Balancer  - All Traffic" 
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      #source_security_group_id = var.ep-prod-alb-sg 
    }
  ]

}

