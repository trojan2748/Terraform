data "aws_ami" "ecs_ami" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
    }
}

data "aws_availability_zones" "aws_azs" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
