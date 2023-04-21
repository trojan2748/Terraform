resource "aws_security_group_rule" "alb_ingress_rules" {
  count             = length(var.alb_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.alb_sg_ingress_rules[count.index].from_port
  to_port           = var.alb_sg_ingress_rules[count.index].to_port
  protocol          = var.alb_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.alb_sg_ingress_rules[count.index].cidr_block]
  description       = var.alb_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.alb_security_group.id
  
}


resource "aws_security_group_rule" "alb_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.alb_security_group.id
}


resource "aws_security_group" "alb_security_group" {
  # vpc_id = var.vpc_id # Todo: update this to the new VPC in QA
  vpc_id = aws_vpc.app_vpc.id
  name = "${var.namespace} - Application Load Balancer security group"
  tags = {
    Name = "${var.namespace} - Application Load Balancer security group"
  }
}


resource "aws_security_group_rule" "asg_ingress_rules" {
  count             = length(var.asg_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.asg_sg_ingress_rules[count.index].from_port
  to_port           = var.asg_sg_ingress_rules[count.index].to_port
  protocol          = var.asg_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.asg_sg_ingress_rules[count.index].cidr_block]
  description       = var.asg_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.asg_security_group.id
  # security_group_id = "sg-015c5f73b13f212f5"
}


resource "aws_security_group_rule" "asg_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.asg_security_group.id
}


resource "aws_security_group" "asg_security_group" {
  vpc_id = aws_vpc.app_vpc.id
  name = "${var.namespace} - Autoscaling Group security group"
  # vpc_id = var.vpc_id # Todo: update this to the new VPC in QA

  tags = {
    Name = "${var.namespace} - Autoscaling Group security group"
  }
}


resource "aws_security_group_rule" "elasticsearch_ingress_rules" {
  count             = length(var.elasticsearch_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.alb_sg_ingress_rules[count.index].from_port
  to_port           = var.alb_sg_ingress_rules[count.index].to_port
  protocol          = var.alb_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.alb_sg_ingress_rules[count.index].cidr_block]
  description       = var.alb_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.elasticsearch_security_group.id
  # security_group_id = "sg-015c5f73b13f212f5"
}

resource "aws_security_group_rule" "elasticsearch_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.elasticsearch_security_group.id
}

resource "aws_security_group" "elasticsearch_security_group" {
  # vpc_id = var.vpc_id # Todo: update this to the new VPC in QA
  vpc_id = aws_vpc.app_vpc.id
  name = "${var.namespace} - Elasticsearch security group"

  tags = {
    Name = "${var.namespace} - Elasticsearch security group"
  }
}
