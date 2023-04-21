#######
# ENV #
#######
variable "env" {
    description     = "Environment acroynm, to be used as a prefix"
    type            = string
    default         = "test"
}

variable "aws_region" {
    description     = "AWS Region to deploy environment in."
    type            = string
    default         = "us-east-1"
}

##########
# VPC    #
##########
variable "vpc_cidr" {
    description     = "VPC CIDR Route"
    type            = string
    default         = "10.10.0.0/16"
}

variable "vpc_private_subnets_count" {
    description     = "Number of private subnets for ECS cluster"
    type            = number
    default         = 3
}

variable "vpc_public_subnets_count" {
    description     = "Number of public subnets for ECS cluster"
    type            = number
    default         = 1
}

variable "vpc_enable_gateway" {
    description     = "Does private subnets have access to internet"
    type            = bool
    default         = true
}

variable "vpc_enable_classiclink" {
    description     = "Enable classic links on VPC"
    type            = bool
    default         = false
}

variable "vpc_enable_classiclink_dns_support" {
    description     = "Enable classic link DNS support on VPC"
    type            = bool
    default         = false
}

variable "vpc_enable_dns_hostnames" {
    description     = ""
    type            = bool
    default         = true
}

variable "vpc_dns_support" {
    description     = ""
    type            = bool
    default         = true
}

/*
variable "" {
    description     = ""
    type            = 
    default         = 
}

variable "" {
    description     = ""
    type            = 
    default         = 
}
*/
