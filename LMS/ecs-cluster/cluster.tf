resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  tags = {
    Name            = var.cluster_name
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "EcsCluster"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}
