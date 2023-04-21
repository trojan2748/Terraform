terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-qa-bkt"
    key            = "project/lms-qa/elasticsearch"
    region         = "us-east-1"
    dynamodb_table = "lms-qa-terraform-state"

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
    bucket = "tf-remote-lms-qa-bkt"
    key    = "project/lms-qa/vpc"
    region = "us-east-1"
    dynamodb_table = "lms-terraform-state"
    //kms_key_id   = "elektra-uat-terraform-state-kms"
  }
}

module "elasticsearch" {

  source                   = "../../"
  domain_name              = "qa-east-es-order"
  instance_type            = "t2.medium.elasticsearch"
  tag_domain               = "LMSQA-east-elasticsearch"
  ebs_volume_size          = "35"
  es_version               = "7.10"
  vpc_id                   = "vpc-03553ead8027017dd"
  subnet_ids               = [ "subnet-050fb8b40fafe1545", "subnet-0fb3bb95d7dba5cc7"  ]
  volume_type              = "gp2"
  ingress_port_range_start = "9200"
  ingress_port_range_end   = "9500"
  log_group_name           = "LMSQA-elasticsearch-log"
  cloudwatch_es_policy     = "lms_qa_elasticsearch_policy"
  log_stream_name          = "lms_qa_elasticsearch_log_stream"
  tags                     = "LMSQA-east-elasticsearch"
  elasticsearch_version    = "7.10"
  instance_count           = "2"
  automated_snapshot_hr    = "1"
  security_group_ids       = [ data.terraform_remote_state.vpc.outputs.elastisearch_security_group_output.id ]
  environment              = "qa"
  availability_zone_count  = 2

}
