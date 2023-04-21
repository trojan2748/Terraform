terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-uat-bkt"
    key            = "project/lms-uat/amazonmq"
    region         = "us-east-1"
    dynamodb_table = "lms-uat-terraform-state"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}


data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tf-remote-lms-uat-bkt"
    key    = "project/lms-uat/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-uat-terraform-state"
  
  }
}

module "amazonmq" {

  source             = "../../"
  engine_type        = "RabbitMQ"
  engine_version     = "3.10.10"
  storage_type       = "ebs"
  host_instance_type = "mq.m5.large"
  deployment_mode    = "CLUSTER_MULTI_AZ"
  broker_name        = "lms-uat-east-amazonmq"
  environment        = "lms-uat"
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*].id
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id

  amazonmq_sg_ingress_rules = [
  
    {
      description = "gl-InfraServices ClientVPN Users"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "192.168.128.0/19"
    }
  ]


}
