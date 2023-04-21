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



##########
# VPC    #
##########
variable "aws_vpc_cidr" {
    description     = "Main VPC CIDR"
    type            = string
    default         = "10.1.0.0/16"
}

variable "aws_num_subnets" {
    description     = "Number of subnets for ECS cluster"
    type            = number
    default         = 3
}


