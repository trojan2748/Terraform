resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = var.cluster_name

  tags = {
    Name            = "${var.cluster_name}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "CloudwatchLogGroup"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}
