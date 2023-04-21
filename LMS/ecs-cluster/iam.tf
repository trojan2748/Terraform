resource "aws_iam_policy" "ecs_host_policy" {
  name        = "${var.environment}-ecs-host-policy"
  description = "${var.platform} ECS host policy."
  policy      = file("${path.module}/resources/ecs_host_policy.json")

  tags = {
    Name            = "${var.environment}-ecs-host-policy"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "IamPolicy"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_iam_role" "ecs_host_role" {
  name = "${var.environment}-ecs-host-role"
  path = "/terraform/${var.platform}/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name            = "${var.environment}-ecs-host-role"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "IamRole"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.ecs_host_role.name
  policy_arn = aws_iam_policy.ecs_host_policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.environment}-profile"
  path = "/terraform/${var.platform}/"
  role = aws_iam_role.ecs_host_role.name

  tags = {
    Name            = "${var.environment}-profile"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "IamInstanceProfile"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}
