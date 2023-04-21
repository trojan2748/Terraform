variable "environment" {

  type        = string
  description = "The isolated environment the module is associated with (e.g. creditservice 'credit', Application `app`)"

}

variable "engine_type" {

  type        = string
  default     = ""
  description = "The engine type for AmazonMQ"

}

variable "engine_version" {

  type        = string
  default     = ""
  description = "The engine version for AmazonMQ"

}

variable "storage_type" {

  type        = string
  default     = ""
  description = "The elastic block storage for AmazonMQ"

}

variable "host_instance_type" {

  type        = string
  default     = ""
  description = "The instance type to choose based on disk size, etc"

}

variable "subnet_ids" {

  type        = list(string)
  default     = [""]
  description = "The subnets for the deployment of AmazonMQ"

}

variable "security_group" {

  type        = list(string)
  default     = [""]
  description = "The security group for the deployment of AmazonMQ"

}

variable "deployment_mode" {

  type        = string
  default     = ""
  description = "The deployment mode to choose whether SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. Default is SINGLE_INSTANCE. "

}

variable "cidr_block" {

  type    = list(string)
  default = [""]

}

variable "vpc_id" {

  type    = string
  default = ""
}

variable "broker_name" {

  type    = string
  default = ""
}

variable "created_by" {
  type    = string
  default = ""
}

variable "amazonmq_sg_ingress_rules" {}

