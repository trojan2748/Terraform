output "vpc_id" {
    description = "Main VPC"
    value       = aws_vpc.main_vpc.id
}

output "ecs_private_subnets" {
    description = "A list of ECS Service cluster private subnets and their attributes"
    value       = aws_subnet.ecs_private_subnets
}
