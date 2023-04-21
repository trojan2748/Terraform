##################
# ECS Agent Role #
##################
data "aws_iam_policy_document" "ecs_instance_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com", "application-autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
    name               = "${var.env}-ecs_instance_role"
    assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy_document.json
}

##############
# Attchments #
##############
resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attachment" {
    role       = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_policy_attachment" {
    role       = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale_policy_attachment" {
    role = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "${var.env}-ecs_instance_profile"
    role = aws_iam_role.ecs_instance_role.name
}
