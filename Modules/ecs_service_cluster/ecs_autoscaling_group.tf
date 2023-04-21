data "aws_ami" "ecs_ami" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
    }
}

data "template_file" "ecs_service_config_template" {
    template = file("${path.module}/files/ecs.config-template.yaml")

    vars = {
        cluster_name    = aws_ecs_cluster.ecs_service_cluster.name
    }
}

resource "aws_launch_configuration" "ecs_service_launch_config" {
    name_prefix                 = "${var.env}-service ECS host-"
    image_id                    = data.aws_ami.ecs_ami.image_id
    iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
    security_groups             = [aws_security_group.ecs_hosts_sg.id]
    key_name                    = "alkeypair"
    user_data                   = data.template_file.ecs_service_config_template.rendered
    instance_type               = var.ecs_service-instace_type

    depends_on                  = [
        aws_security_group.ecs_hosts_sg
    ]

    lifecycle {
        create_before_destroy   = true
    }
}


resource "aws_autoscaling_group" "ecs_service_cluster_asg" {
    name_prefix                 = "${var.env}-asg-service-"
    vpc_zone_identifier         = [for subnet in aws_subnet.ecs_private_subnets : subnet.id]
    launch_configuration        = aws_launch_configuration.ecs_service_launch_config.name

    desired_capacity            = var.ecs_service-desired_capacity
    min_size                    = var.ecs_service-min_size
    max_size                    = var.ecs_service-max_size
    health_check_grace_period   = 300

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    tag {
        key                     = "cluster"
        value                   = aws_ecs_cluster.ecs_service_cluster.name
        propagate_at_launch     = true
    }
}

