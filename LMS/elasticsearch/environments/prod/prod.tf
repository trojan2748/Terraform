terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-prod-bkt"
    key            = "project/lms-prod/elasticsearch"
    region         = "us-east-1"
    dynamodb_table = "lms-prod-terraform-state"

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
    bucket = "tf-remote-lms-prod-bkt"
    key    = "project/lms-prod/vpc"
    region = "us-east-1"
    dynamodb_table = "lms-prod-terraform-state"
    //kms_key_id   = "elektra-uat-terraform-state-kms"
  }
}

module "elasticsearch" {

  source                   = "../../"
  domain_name              = "prod-east-es-order"
  instance_type            = "r5.2xlarge.elasticsearch"
  tag_domain               = "LMSPROD-east-elasticsearch"
  ebs_volume_size          = "35"
  es_version               = "7.10"
  vpc_id                   = "vpc-0dbca83635a3d7360"
  subnet_ids               = [ "subnet-06b9b8f4ffe26d4e0", "subnet-0bf49101154bbca5f"  ]
  volume_type              = "gp2"
  ingress_port_range_start = "9200"
  ingress_port_range_end   = "9500"
  log_group_name           = "LMSPROD-elasticsearch-log"
  cloudwatch_es_policy     = "lms_prod_elasticsearch_policy"
  log_stream_name          = "lms_prod_elasticsearch_log_stream"
  tags                     = "LMSPROD-east-elasticsearch"
  elasticsearch_version    = "7.10"
  instance_count           = "2"
  automated_snapshot_hr    = "1"
  security_group_ids       = [ data.terraform_remote_state.vpc.outputs.elastisearch_security_group_output.id ]
  environment              = "prod"
  availability_zone_count  = 2

}
