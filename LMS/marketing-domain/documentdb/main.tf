data "aws_ssm_parameter" "documentdb_username" {
  name = "/${var.domain}-${var.environment}/marketing/documentdb_username"
}

data "aws_ssm_parameter" "documentdb_password" {
  name = "/${var.domain}-${var.environment}/marketing/documentdb_password"
}

resource "aws_kms_key" "documentdb_kms_key" {

  description       = "Documentdb KMS encryption key."

  tags = {
    Name            = "${var.domain}-${var.environment}-documentdb-kms-key"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${var.environment}"
    BillingSubGroup = "DocumentDB"
    Environment     = var.environment
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }
}

resource "aws_kms_alias" "document_db_kms_key_alias" {
  name          = var.key_alias
  target_key_id = aws_kms_key.documentdb_kms_key.key_id
}

resource "aws_security_group" "documentdb_security_group" {
  name        = "${var.domain}-${var.environment}-marketing-docdb-security-group"
  vpc_id      = var.vpc_id
  description = "allows access from anywhere in the ${var.environment}1 VPC"

  tags = {
    Name            = "${var.domain}-${var.environment}-documentdb-security-group"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${var.environment}"
    BillingSubGroup = "DocumentDB"
    Environment     = var.environment
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }
}


resource "aws_security_group_rule" "docdb_ingress_rules" {
  count             = length(var.docdb_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.docdb_sg_ingress_rules[count.index].from_port
  to_port           = var.docdb_sg_ingress_rules[count.index].to_port
  protocol          = var.docdb_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.docdb_sg_ingress_rules[count.index].cidr_block]
  description       = var.docdb_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.documentdb_security_group.id
  
}

resource "aws_security_group_rule" "source_docdb_ingress_rules_1" {
  count             = 1
  type              = "ingress"
  from_port         = var.source_docdb_ingress_rules[count.index].from_port
  to_port           = var.source_docdb_ingress_rules[count.index].to_port
  protocol          = var.source_docdb_ingress_rules[count.index].protocol
  source_security_group_id   = var.lms-asg-sg
  description       = "(Security Group) lms-${var.environment} - Autoscaling Group security group - All Traffic"
  security_group_id = aws_security_group.documentdb_security_group.id
  
}

resource "aws_security_group_rule" "source_docdb_ingress_rules_2" {
  count             = 1
  type              = "ingress"
  from_port         = var.source_docdb_ingress_rules[count.index].from_port
  to_port           = var.source_docdb_ingress_rules[count.index].to_port
  protocol          = var.source_docdb_ingress_rules[count.index].protocol
  source_security_group_id   = var.lms-alb-sg
  description       = "(Security Group)  lms-${var.environment} - Application Load Balancer  - All Traffic" 
  security_group_id = aws_security_group.documentdb_security_group.id
  
}

resource "aws_security_group_rule" "docdb_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.documentdb_security_group.id
}

#aws_docdb_cluster
resource "aws_docdb_cluster" "lms_documentdb" {
  for_each                        = var.create ? var.cluster_details : {}
  cluster_identifier              = "${var.env}-${each.value["identifier"]}"
  master_username                 = data.aws_ssm_parameter.documentdb_username.value
  master_password                 = data.aws_ssm_parameter.documentdb_password.value
  port                            = 27017
  deletion_protection             = false
  engine_version                  = each.value["engine_version"]
  engine                          = each.value["engine"]
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  storage_encrypted               = var.storage_encrypted
  backup_retention_period         = each.value["backup_retention_period"]
  skip_final_snapshot             = var.skip_final_snapshot
  vpc_security_group_ids          = [ aws_security_group.documentdb_security_group.id ]
  db_subnet_group_name            = var.db_subnet_group_name
  kms_key_id                      = aws_kms_key.documentdb_kms_key.arn


  tags = {
    Name            = "${var.environment}-documentdb-cluster"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${var.domain}"
    BillingSubGroup = "DocumentDB"
    Environment     = var.environment
    RequestedBy     = "sre@glidewelldental.com"
    CreatedBy       = "sre@glidewelldental.com"
  }
}


# Create 3 cluster instances; have to break this into 3 different blocks becuase you can't use count and for_each in the same block
resource "aws_docdb_cluster_instance" "lms_documentdb_instance_1" {
  for_each           = var.create ? var.cluster_details : {}
  identifier         = "${var.env}-${each.value["identifier"]}-1"              
  cluster_identifier = "${var.env}-${each.value["identifier"]}"   
  instance_class     = var.instance_class
  depends_on         = [ aws_docdb_cluster.lms_documentdb  ]
}


resource "aws_docdb_cluster_instance" "lms_documentdb_instance_2" {
  for_each           = var.create ? var.cluster_details : {}
  identifier         = "${var.env}-${each.value["identifier"]}-2"    
  cluster_identifier = "${var.env}-${each.value["identifier"]}"    
  instance_class     = var.instance_class
  depends_on         = [ aws_docdb_cluster.lms_documentdb  ]
}

resource "aws_docdb_cluster_instance" "lms_documentdb_instance_3" {
  for_each           = var.create ? var.cluster_details : {}
  identifier         = "${var.env}-${each.value["identifier"]}-3"
  cluster_identifier = "${var.env}-${each.value["identifier"]}"    
  instance_class     = var.instance_class
  depends_on         = [ aws_docdb_cluster.lms_documentdb  ]
}
