########################
# Common variables
########################

variable "environment" {}
variable "application" {}
variable "aws_account" {}
#variable "domain" {} 
variable "platform" {}
variable "env" {}

########################
# Cluster variables
########################

variable "cluster_name" {}
variable "ami_id" {}
variable "vpc_id" {}
# variable "sg_ingress_rules" {
#   type = list(object({
#     description = string
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_block  = string
#   }))
# }

########################
# Capacity provider
########################

variable "managed_scaling_max_step_size" {}
variable "managed_scaling_mix_step_size" {}
variable "managed_scaling_target_capacity" {}

########################
# Launch template
########################

variable "instance_type" {}

########################
# Autoscaling group
########################

variable "availability_zones" {}
variable "asg_desired_capacity" {}
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "override_instance_type" {}
variable "override_weight" {}
variable "vpc_zone_identifier" {}
variable "autoscaling_group_name" {}
variable "vpc_security_group_ids" {}
#variable "lms_autoscaling_security_group" {}


########################
# Route 53
########################
variable "create_hosted_zone" {}
variable "hosted_zone_name" {}

########################
# Load balancer
########################

variable "lb_name" {}
variable "lb_subnets" {}
variable "lb_enable_deletion_protection" {}
variable "security_groups" {}
#variable "lms_lb_ingress_rules" {}
#variable "lms_lb_egress_rules" {}
#variable "lms_asg_ingress_rules" {}
#variable "lms_asg_egress_rules" {}
#variable "lms_lb_security_group_name" {}