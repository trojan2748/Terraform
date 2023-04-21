resource "aws_ecs_cluster" "ecs_service_cluster" {
    name = "${var.env}-service"
    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

