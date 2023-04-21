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

  environment = "dev"
  domain      = "lms"
  region      = "east"
  aws_account = "lms-dev"

}


module "postgresql" {

  source                      = "../../"
  engine_version              = "12.8"
  engine                      = "postgres"
  instance_class              = "db.t3.small"
  allocated_storage           = "20"
  storage_type                = "gp2"
  storage_encrypted           = false
  family                      = "postgres12"
  identifier                  = "lms-dev-east-products"
  db_name                     = "products"
  db_instance_port            = "5432"
  multi_az                    = "true"
  iops                        = 0
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = false
  skip_final_snapshot         = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  backup_retention_period         = "7"
  lms-asg-sg                      = "sg-02c16144bf6ce0c7b"
  lms-alb-sg                      = "sg-074beef40f34b6d32"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  deletion_protection             = false
  delete_automated_backups        = true
  db_subnet_group_name            = "lms-dev-db-subnet-group"
  parameter_group_name            = "lms-dev-db-pg"
  maintenance_window              = "Mon:00:00-Mon:03:00"
  subnet_ids                      = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*].id
  vpc_id                          = data.terraform_remote_state.vpc.outputs.vpc_id
  domain                          = local.domain
  environment                     = local.environment
  postgres_sg_ingress_rules = [
  
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

  source_postgres_ingress_rules  = [
     
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
  
  #######################
  # KMS
  ######################

  key_alias = "alias/${local.environment}-${local.region}-${local.domain}-postgres"


}
