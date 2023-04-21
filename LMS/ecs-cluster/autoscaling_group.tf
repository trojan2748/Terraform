data "template_file" "user_data_template" {
  template = file("${path.module}/resources/user_data.sh")

  vars = {
    cluster_name = "${var.cluster_name}"
  }
}

data "aws_ami" "ami" {
  owners = ["amazon"]

  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

resource "aws_launch_template" "launch_template" {
  name          = "${var.environment}-launch-template"
  image_id      = data.aws_ami.ami.id
  instance_type = var.instance_type
  key_name      = "${var.aws_account}-ecs" # 
  user_data     = base64encode("${data.template_file.user_data_template.rendered}")

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 150
    }
  }

  #vpc_security_group_ids = var.vpc_security_group_ids != "" ? [var.vpc_security_group_ids] : [data.terraform_remote_state.vpc.outputs.asg_security_group_output.id]
  vpc_security_group_ids = var.vpc_security_group_ids
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name            = "${var.autoscaling_group_name}"
      DeptOwner       = "SRE"
      DeptSubOwner    = "Infrastructure"
      BillingGroup    = "${var.platform}"
      BillingSubGroup = "LaunchTemplate"
      Environment     = var.environment
      CreatedBy       = "SRETeam@glidewelldental.com"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm_up" {
  alarm_name          = "${var.environment}-metric-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  alarm_description = "This metric monitors ec2 memory utilization"
  alarm_actions     = [aws_autoscaling_policy.mem_autoscaling_policy_up.arn]

  tags = {
    Name            = "${var.environment}-metric-alarm-up"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "CloudwatchMetricAlarm"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm_down" {
  alarm_name          = "${var.environment}-metric-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  alarm_description = "This metric monitors ec2 memory utilization"
  alarm_actions     = [aws_autoscaling_policy.mem_autoscaling_policy_down.arn]

  tags = {
    Name            = "${var.environment}-metric-alarm-down"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "CloudwatchMetricAlarm"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_autoscaling_policy" "mem_autoscaling_policy_up" {
  name                   = "${var.environment}-memory-policy-up"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_autoscaling_policy" "mem_autoscaling_policy_down" {
  name                   = "${var.environment}-memory-policy-down"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_autoscaling_policy" "cpu_autoscaling_policy" {
  name                   = "${var.environment}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.environment}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.autoscaling_group.arn
    # managed_termination_protection = "ENABLED" # We should eventually enable this, but during development, it causes problems when recreating resource
  }

  tags = {
    Name            = "${var.environment}-capacity-provider"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "${var.platform}"
    BillingSubGroup = "EcsCapacityProvider"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                = var.autoscaling_group_name
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
        version            = "$Latest"
      }
    }
  }

  tags = concat(
    [
      {
        "key"                 = "DeptOwner"
        "value"               = "SRE"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "DeptSubOwner"
        "value"               = "Infrastructure"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "BillingGroup"
        "value"               = "${var.platform}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "BillingSubGroup"
        "value"               = "AutoScalingGroup"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = var.environment
        "propagate_at_launch" = true
      },
      {
        "key"                 = "CreatedBy"
        "value"               = "SRETeam@glidewelldental.com"
        "propagate_at_launch" = true
      }
    ],
  )
}

/*
resource "aws_route53_zone" "hosted_zone" {
  count = var.create_hosted_zone == true ? 1 : 0
  name  = var.hosted_zone_name
}
*/
