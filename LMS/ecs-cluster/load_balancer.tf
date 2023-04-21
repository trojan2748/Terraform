resource "aws_lb" "load_balancer" {
  name                       = var.lb_name # Limit this to 32 chars because of AWS constraint
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = var.security_groups   
  subnets                    = var.lb_subnets
  enable_deletion_protection = var.lb_enable_deletion_protection

  tags = {
    Name            = substr(var.lb_name, 0, 32) # Limit this to 32 chars because of AWS constraint
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "ApplicationLoadBalancer"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}
