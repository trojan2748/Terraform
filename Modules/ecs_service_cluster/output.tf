output "ecs_cluster_id" {
    description = "ECS Cluster id"
    value       = aws_ecs_cluster.ecs_service_cluster.id
}

output "ecs_instance_role_arn" {
    description = "IAM Role for ECS EC2 instances."
    value       = aws_iam_role.ecs_instance_role.arn
}

output "vpc_sg_arn" {
    description = "VPC SG ARN"
    value       = aws_security_group.ecs_hosts_sg.arn
}

#output "vpc_public_subnets" {
#    description = "Public subnet(s) for VPC"
#    value       = aws_subnet.ecs_public_subnets
#}

#output "vpc_private_subnets" {
#    description = "Private subnet(s) for VPC"
#    value       = aws_subnet.ecs_private_subnets
#}

output "vpc_gateway_arn" {
    description = "ARN of VPC Internet Gateway for public routing"
    value       = aws_internet_gateway.ecs_internet_gateway.arn
}

output "vpc_gateway_ip" {
    description = "IP Address of VPC Internet Gateway"
    value       = aws_eip.ecs_nat_gw_eip.public_ip
}

output "vpc_cidr" {
    description = ""
    value       = var.vpc_cidr
}

output "vpc_id" {
    description = ""
    value       = aws_vpc.main_vpc.id
}
