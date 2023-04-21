output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.app_vpc.id
}


output "public_subnets_ids" {
  description = "All public subnets."
  value       = aws_subnet.app_public_subnets
}


output "private_subnets_ids" {
  description = "All public subnets."
  value       = aws_subnet.app_private_subnets
}


output "database_subnets_ids" {
  description = "All public subnets."
  value       = aws_subnet.database_subnets
}


output "asg_security_group_output" {
  description = "Security group for the autoscaling group."
  value       = aws_security_group.asg_security_group
}


output "alb_security_group_output" {
  description = "Security group for the autoscaling group."
  value       = aws_security_group.alb_security_group
}


output "elasticsearch_security_group_output" {
  description = "Security group for the autoscaling group."
  value       = aws_security_group.elasticsearch_security_group
}

