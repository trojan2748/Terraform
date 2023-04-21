data "aws_ssm_parameter" "amazonmq_username" {
  name = "/${var.environment}/amazonmq/amazonmq_username"
}

data "aws_ssm_parameter" "amazonmq_password" {
  name = "/${var.environment}/amazonmq/amazonmq_password"
}

#AMAZONMQ BROKER 
#RabbitMQ engine type doesn't require aws mq configuration
resource "aws_mq_broker" "lms_amazonmq" {

  broker_name                = var.broker_name
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  storage_type               = var.storage_type
  host_instance_type         = var.host_instance_type
  security_groups            = [ aws_security_group.amazonmq_security_group.id ]
  auto_minor_version_upgrade = true
  subnet_ids                 = var.subnet_ids
  deployment_mode            = var.deployment_mode

  logs {
    general = true
  }

  user {
    username = data.aws_ssm_parameter.amazonmq_username.value
    password = data.aws_ssm_parameter.amazonmq_password.value
  }

  tags = {
    Name            = "${var.broker_name}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "AmazonMQ"
    Environment     = var.environment
    CreatedBy       = "sre@glidewelldental.com"
  }
}


#Security group for AmazonMQ 
resource "aws_security_group" "amazonmq_security_group" {
  name              = "${var.environment}-amazonmq-security-group"
  vpc_id            = var.vpc_id
  description       = "allows access from anywhere in the ${var.environment}1 VPC"

  tags = {
    Name            = "${var.environment}-amazonmq-security-group"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${var.environment}"
    BillingSubGroup = "AmazonMQ"
    Environment     = var.environment
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }
}

#Amazonmq ingress rule
resource "aws_security_group_rule"   "amazonmq_ingress_rules" {
  count             = length(var.amazonmq_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.amazonmq_sg_ingress_rules[count.index].from_port
  to_port           = var.amazonmq_sg_ingress_rules[count.index].to_port
  protocol          = var.amazonmq_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [ var.amazonmq_sg_ingress_rules[count.index].cidr_block ]
  description       = var.amazonmq_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.amazonmq_security_group.id
  
}

#Amazonmq egress rule
resource "aws_security_group_rule"  "amazonmq_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.amazonmq_security_group.id
}

