variable "name" {
  type        = string
  default     = ""
  description = "The name of the module"
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "azs" {
  type    = list(string)
  default = [""]
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = [""]
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = [""]
}

variable "bridge_subnets_cidr" {
  type    = list(string)
  default = [""]
}

variable "database_subnets_cidr" {
  type    = list(string)
  default = [""]
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name`"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization abbreviation, client name, etc. (e.g. Crownworld 'cw', HashiCorp 'hc')"
}

variable "environment" {
  type        = string
  default     = ""
  description = "The isolated environment the module is associated with (e.g. creditservice 'credit', Application `app`)"
}

variable "stage" {
  type        = string
  default     = ""
  description = "The development stage (i.e. `dev`, `stg`, `prd`)"
}

variable "create" {
  type    = bool
  default = true

}

variable "transit_gateway_id" {
  type    = string
  default = true
  description = "The transit gateway id"
}

locals {

  environment_prefix = join(var.delimiter, compact([var.namespace, var.environment]))
  stage_prefix       = join(var.delimiter, compact([var.stage, local.environment_prefix]))
  module_prefix      = join(var.delimiter, compact([local.stage_prefix, var.name]))
  tag_prefix         = join(var.delimiter, compact([var.namespace, var.stage]))
}

variable "alb_sg_ingress_rules" {}
variable "asg_sg_ingress_rules" {}
variable "elasticsearch_sg_ingress_rules" {}
variable "transit_gateway_path" {}
