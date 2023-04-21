####################
# Policy Documents #
####################
data "aws_iam_policy_document" "ecsExternalInstanceRole_policy_document" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ssm.amazonaws.com"]
        }
    }
}


############
# Policies #
############
resource "aws_iam_policy" "ecs_read_cluster" {
    name = "ECSAnywhere_Traefik_ECSRead-${var.env}-policy"
    policy = "${file("documents/policy_ecsanywhere_traefik_ECSRead.json")}"
}

resource "aws_iam_policy" "ecs_cloudwatch_policy" {
    name = "ECSAnywhere_Cloudwatch-${var.env}-policy"
    policy = "${file("documents/policy_ecsanywhere_cloudwatch_server.json")}"
}

#resource "aws_iam_policy" "ssm_session_policy" {
#    name = "SSM_Session-${var.env}-policy"
#    policy = "${file("documents/policy_ssm_session.json")}"
#}


#########
# Roles #
#########
resource "aws_iam_role" "ecsExternalInstanceRole" {
    name = "${var.env}-ecsExternalInstanceRole"
    assume_role_policy = data.aws_iam_policy_document.ecsExternalInstanceRole_policy_document.json

    depends_on          = [data.aws_iam_policy_document.ecsExternalInstanceRole_policy_document]
}

###############
# Attachments #
###############
resource "aws_iam_role_policy_attachment" "attach_policy_AmazonSSMManagedInstanceCore" {
    role        = aws_iam_role.ecsExternalInstanceRole.name
    policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "attach_policy_AmazonEC2ContainerServiceforEC2Role" {
    role        = aws_iam_role.ecsExternalInstanceRole.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_role_policy_attachment" "attach_policy_CloudWatchAgentServerPolicy" {
    role        = aws_iam_role.ecsExternalInstanceRole.name
    policy_arn  = aws_iam_policy.ecs_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_ecs_read_cluster" {
    role        = aws_iam_role.ecsExternalInstanceRole.name
    policy_arn  = aws_iam_policy.ecs_read_cluster.arn
}

#resource "aws_iam_role_policy_attachment" "attach_policy_ssm_session" {
#    role        = aws_iam_role.ecsExternalInstanceRole.name
#    policy_arn  = aws_iam_policy.ssm_session_policy.arn
#}

##################
# SSM Activation #
##################
resource "aws_ssm_activation" "ssm_activiation" {
    name               = "${var.env}-ecsanywhere_ssm_activation"
    description        = "SSM activation for ecs anywhere servers"
    iam_role           = aws_iam_role.ecsExternalInstanceRole.id
    registration_limit = "10"
    depends_on         = [aws_iam_role_policy_attachment.attach_policy_AmazonSSMManagedInstanceCore, time_sleep.wait_15_seconds]
}
