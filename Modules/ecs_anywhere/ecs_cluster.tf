#######################
# ECSAnywhere cluster #
#######################
resource "aws_ecs_cluster" "ecs_service_cluster" {
    name = "${var.env}-ecsAnywhereCluster"
    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}
