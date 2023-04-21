terraform {
  backend "s3" {

    bucket         = "tf-remote-lms-dev-bkt"
    key            = "project/lms-dev/elasticsearch"
    region         = "us-east-1"
    dynamodb_table = "lms-terraform-state"

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
    bucket = "tf-remote-lms-dev-bkt"
    key    = "project/lms-dev/vpc-deployment"
    region = "us-east-1"
    dynamodb_table = "lms-terraform-state"
    //kms_key_id   = "elektra-uat-terraform-state-kms"
  }
}


module "elasticsearch" {

  source                   = "../../"
  domain_name              = "dev-east-es-order"
  instance_type            = "t2.medium.elasticsearch"
  tag_domain               = "LMSDEV-east-elasticsearch"
  ebs_volume_size          = "35"
  es_version               = "7.10"
  vpc_id                   = "vpc-023df3891901d96d4"
  subnet_ids               = [ "subnet-0ccf008a1835530fa","subnet-0f526b85a6e3f10ed" ] 
  volume_type              = "gp2"
  ingress_port_range_start = "9200"
  ingress_port_range_end   = "9500"
  log_group_name           = "LMSdev-elasticsearch-log"
  cloudwatch_es_policy     = "lms_dev_elasticsearch_policy"
  log_stream_name          = "lms_dev_elasticsearch_log_stream"
  tags                     = "LMSDEV-east-elasticsearch"
  elasticsearch_version    = "7.10"
  instance_count           = "2"
  automated_snapshot_hr    = "1"
  security_group_ids       = [ data.terraform_remote_state.vpc.outputs.elastisearch_security_group_output.id ]
  environment              = "lms-dev"
  availability_zone_count  = 2

}
