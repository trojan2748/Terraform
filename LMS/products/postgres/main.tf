#SSM Parameter Store
data "aws_ssm_parameter" "postgresql_username" {
  name = "/${var.domain}-${var.environment}/postgresql/username"
}

data "aws_ssm_parameter" "postgresql_password" {
  name = "/${var.domain}-${var.environment}/postgresql/password"
}


#AWS KMS Key
resource "aws_kms_key" "postgresql_kms_key" {

  description       = "Postgresql KMS encryption key."

  tags = {
    Name            = "${var.domain}-${var.environment}-postgresql-kms-key"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${environment}"
    BillingSubGroup = "Postgresql"
    Environment     = var.environment
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }
}

resource "aws_kms_alias" "postgresql_db_kms_key_alias" {
  name          = var.key_alias
  target_key_id = aws_kms_key.postgresql_kms_key.key_id
}

# Security Group
resource "aws_security_group" "postgres_security_group" {
  name        = "${var.domain}-${var.environment}-postgres-security-group"
  vpc_id      = var.vpc_id
  description = "allows access from anywhere in the ${var.environment}1 VPC"

  tags = {
    Name            = "${var.domain}-${var.environment}-postgres-security-group"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS: ${var.environment}"
    BillingSubGroup = "postgresql"
    Environment     = var.environment
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }
}


resource "aws_security_group_rule" "postgres_ingress_rules" {
  count             = length(var.postgres_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.postgres_sg_ingress_rules[count.index].from_port
  to_port           = var.postgres_sg_ingress_rules[count.index].to_port
  protocol          = var.postgres_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.postgres_sg_ingress_rules[count.index].cidr_block]
  description       = var.postgres_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.postgres_security_group.id
  
}

resource "aws_security_group_rule" "source_postgres_ingress_rules_1" {
  count             = 1
  type              = "ingress"
  from_port         = var.source_postgres_ingress_rules[count.index].from_port
  to_port           = var.source_postgres_ingress_rules[count.index].to_port
  protocol          = var.source_postgres_ingress_rules[count.index].protocol
  source_security_group_id   = var.lms-asg-sg
  description       = "(Security Group) lms-${var.environment} - Autoscaling Group security group - All Traffic"
  security_group_id = aws_security_group.postgres_security_group.id
  
}

resource "aws_security_group_rule" "source_postgres_ingress_rules_2" {
  count             = 1
  type              = "ingress"
  from_port         = var.source_postgres_ingress_rules[count.index].from_port
  to_port           = var.source_postgres_ingress_rules[count.index].to_port
  protocol          = var.source_postgres_ingress_rules[count.index].protocol
  source_security_group_id   = var.lms-alb-sg
  description       = "(Security Group)  lms-${var.environment} - Application Load Balancer  - All Traffic" 
  security_group_id = aws_security_group.postgres_security_group.id
  
}

resource "aws_security_group_rule" "docdb_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.postgres_security_group.id
}



#Create a Database Using the RDS Instance in AWS
resource "aws_db_instance" "products" {
  
  count                           = var.create ? 1 : 0
  identifier                      = var.identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  allocated_storage               = var.allocated_storage
  storage_type                    = var.storage_type
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = aws_kms_key.postgresql_kms_key.arn
  db_name                         = var.db_name
  username                        = data.aws_ssm_parameter.postgresql_username.value
  password                        = data.aws_ssm_parameter.postgresql_password.value      
  port                            = var.db_instance_port
  vpc_security_group_ids          = [ aws_security_group.postgres_security_group.id ]
  db_subnet_group_name            = aws_db_subnet_group.products_db_subnet_group.name
  parameter_group_name            = aws_db_parameter_group.products_db_pg.name
  #option_group_name              = var.option_group_name
  #availability_zone              = var.azs
  multi_az                        = var.multi_az
  iops                            = var.iops
  publicly_accessible             = var.publicly_accessible
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  apply_immediately               = var.apply_immediately
  maintenance_window              = var.maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot
  backup_retention_period        = var.backup_retention_period
  #max_allocated_storage          = var.max_allocated_storage
  #monitoring_interval            = var.monitoring_interval
  #monitoring_role_arn            = var.monitoring_interval > 0 ? local.monitoring_role_arn : null

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection
  delete_automated_backups        = var.delete_automated_backups

  tags = {
      Name           = var.db_name
      DeptOwner       = "SRE"
      DeptSubOwner    = "Infrastructure"
      BillingGroup    = "LMS"
      BillingSubGroup = "Postgresql"
      Environment     = var.environment
      CreatedBy       = "SRE@glidewelldental.com"
  }

}

resource "aws_db_parameter_group" "products_db_pg" {
  name          = var.parameter_group_name
  family        = var.family

}

resource "aws_db_subnet_group" "products_db_subnet_group" {
  name          = var.db_subnet_group_name
  subnet_ids    = var.subnet_ids

  tags = {
    Name = "DB_subnet_group"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "DB Parameter Group"
    Environment     = var.environment
    CreatedBy       = "SRE@glidewelldental.com"
  }
}
