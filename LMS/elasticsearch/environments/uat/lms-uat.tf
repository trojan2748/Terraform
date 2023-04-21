terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-uat-bkt"
    key            = "project/lms-uat/elasticsearch"
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
    dynamodb_table = "lms-terraform-state"
    //kms_key_id   = "elektra-uat-terraform-state-kms"
  }
}

module "elasticsearch" {

  source                   = "../../"
  domain_name              = "uat-east-es-order"
  instance_type            = "r5.2xlarge.elasticsearch"
  tag_domain               = "LMSUAT-east-elasticsearch"
  ebs_volume_size          = "35"
  es_version               = "7.10"
  vpc_id                   = "vpc-0b7884aeec3cb2a67"
  subnet_ids               = [ "subnet-0c74bb95d94b99628", "subnet-0394583c6faae9f98"  ]
  volume_type              = "gp2"
  ingress_port_range_start = "9200"
  ingress_port_range_end   = "9500"
  log_group_name           = "LMSUAT-elasticsearch-log"
  cloudwatch_es_policy     = "lms_uat_elasticsearch_policy"
  log_stream_name          = "lms_uat_elasticsearch_log_stream"
  tags                     = "LMSUAT-east-elasticsearch"
  elasticsearch_version    = "7.10"
  instance_count           = "2"
  automated_snapshot_hr    = "1"
  security_group_ids       = [ data.terraform_remote_state.vpc.outputs.elastisearch_security_group_output.id ]
  environment              = "uat"
  availability_zone_count  = 2

}
