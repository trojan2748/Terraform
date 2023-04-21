# Used by ALB
resource "aws_security_group" "ecs_loadbalancers_sg" {
    name        = "${var.env}-ecs_loadbalancers_sg"
    description = "Security Group for ECS/EC2 ELB/ALB"
    vpc_id      = aws_vpc.main_vpc.id

    ingress {
        description = "(ALL Traffic) - (Security Group) - Self"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
    }

    ingress {
        description = "(ALL Traffic) - Main VPC"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr]
      }

    ingress {
        description = "(ALL Traffic) - ClientVPN"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["192.168.64.0/18"]
    }

    ingress {
        description = "(ALL Traffic) - GDL"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["12.201.82.0/24"]
    }

    ingress {
        description = "(ALL Traffic) - DC6"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["12.1.209.224/28"]
    }

    ingress {
        description     = "(ALL Traffic) - (Security Group) - ${var.env} - ECS EC2 hosts security group"
        security_groups = [aws_security_group.ecs_hosts_sg.id]
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
    }
/*
    ingress {
        description     = "(ALL Traffic) - (Security Group) - ${var.env} - ECS EC2 elasticsearch security group"
        security_groups = [aws_security_group.ecs_elasticsearch_sg.id]
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
    }
*/
    egress {
        description = "(ALL Traffic)"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
/*
resource "aws_security_group" "ecs_elasticsearch_sg" {
    name        = "${var.env}-ecs_elasticesearch_hosts_sg"
    description = "Security Group for ECS/EC2 ELB/ALB"
    vpc_id      = aws_vpc.main_vpc.id

    ingress {
        description = "(ALL Traffic) - Main VPC"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr]
    }

    ingress {
        description = "(ALL Traffic) - ClientVPN"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["192.168.64.0/18"]
    }

    ingress {
        description = "(ALL Traffic) - Pega Public"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["161.32.32.0/20"]
    }

    ingress {
        description = "(PostgreSQL) - Pega"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["198.18.0.0/16", "161.32.32.0/20"]
    }

    ingress {
        description = "(MySQL) - Pega"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["198.18.0.0/16", "161.32.32.0/20"]
    }

    egress {
        description = "(ALL Traffic)"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
*/

# Used by ECS/EC2 autoscaling_group
resource "aws_security_group" "ecs_hosts_sg" {
    name        = "${var.env}-ecs_hosts_sg"
    description = "Security Group for ECS EC2 instances"
    vpc_id      = aws_vpc.main_vpc.id

    ingress {
        description = "(ALL Traffic) - Main VPC"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr]
    }

    ingress {
        description = "(ALL Traffic) - ClientVPN"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["192.168.64.0/18"]
    }

    ingress {
        description = "(ALL Traffic) - GDL"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["12.201.82.0/24"]
    }

    ingress {
        description = "(ALL Traffic) - Workspaces NATGWY"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["100.21.192.90/32"]
    }

    ingress {
        description = "(ALL Traffic) - Office DC6"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["12.1.209.224/28"]
    }

    ingress {
        description = "(PostgreSQL) - Pega"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["198.18.0.0/16", "161.32.32.0/20"]
    }

    ingress {
        description = "(MySQL) - Pega"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["198.18.0.0/16", "161.32.32.0/20"]
    }

    egress {
        description = "(ALL Traffic)"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#################
# Binding rules #
#################
/*
resource "aws_security_group_rule" "ecs_loadbalancers_to_ecs_elasticsearch" {
    description              = "(ALL Traffic) - (Security Group) - ${var.env}-ecs_loadbalancers to ${var.env}-ecs_elasticsearch"
    security_group_id        = aws_security_group.ecs_elasticsearch_sg.id
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    type                     = "ingress"
    source_security_group_id = aws_security_group.ecs_loadbalancers_sg.id
}
*/
resource "aws_security_group_rule" "ecs_loadbalancers_to_ecs_hosts" {
    description              = "(ALL Traffic) - (Security Group) - ${var.env}-ecs_loadbalancers to ${var.env}-ecs_hosts"
    security_group_id        = aws_security_group.ecs_hosts_sg.id
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    type                     = "ingress"
    source_security_group_id = aws_security_group.ecs_loadbalancers_sg.id
}
