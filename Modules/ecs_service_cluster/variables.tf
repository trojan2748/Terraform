#################
# ENV Variables #
#################
variable "aws_region" {
    description     = "AWS Region to deploy environment in."
    type            = string
    default         = "us-east-1"
}

variable "env" {
    description     = "Environment acroynm, to be used as a prefix"
    type            = string
    default         = "test"
}


#########################
# VPC/Network Variables #
#########################
#variable "vpc_id" {
#    description     = "VPC ID from network module"
#    type            = string
#}

variable "vpc_cidr" {
    description     = "CIDR to run ECS EC2 instances "
    type            = string
}

variable "public_routing_enabled" {
    description     = "Creates public subnets. Allow public routing from subnets. Create SGs to allow routing"
    type            = number
    default         = 1
}

variable "az_count" {
    description     = "The amount of Availability Zones to deploy ECS EC2 instances into"
    type            = number
    default         = 1
}

#################
# EC2 Variables #
#################
variable "ecs_service-instace_type" {
    description     = "EC2 instance type to be used in cluster"
    type            = string
    default         = "t3.micro"
}

variable "ecs_service-min_size" {
    description     = "Minimum amount of EC2 instances in ECS Cluster"
    type            = number
    default         = 1
}

variable "ecs_service-max_size" {
    description     = "Maximum amount of EC2 instances in ECS Cluster"
    type            = number
    default         = 2
}

variable "ecs_service-desired_capacity" {
    description     = "Desired capacity"
    type            = number
    default         = 1
}

#################
# ALB Variables #
#################
variable "alb_count" {
    description     = "How many ALBs to create"
    type            = number
    default         = 1
}

variable "alb_ingress_rules" {
    description     = "A list of ingress rules for ALB"
    default         = ""
}

