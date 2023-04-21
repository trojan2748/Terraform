resource "aws_security_group" "ecs_hosts_sg" {
    name        = "${var.env}-ecs_hosts_sg"
    description = "Security Group for ECS EC2 instances"
    vpc_id      = aws_vpc.vpc.id

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
        cidr_blocks = ["0.0.0.0/0"]
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
