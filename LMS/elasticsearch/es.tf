# Cloudwatch log group and stream 
resource "aws_cloudwatch_log_group" "lms_elasticsearch_log" {
  name = var.log_group_name

  tags = {
    Name            = var.log_group_name
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "CloudwatchLogGroup"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

resource "aws_cloudwatch_log_resource_policy" "lms_elasticsearch_policy" {
  policy_name = var.cloudwatch_es_policy

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "*"
    }
  ]
}
CONFIG
}


# Cloudwatch log stream
resource "aws_cloudwatch_log_stream" "lms_elasticsearch_stream" {

  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.lms_elasticsearch_log.name

}

# Creating the Elasticsearch domain
resource "aws_elasticsearch_domain" "lms_elasticsearch" {
  domain_name              = var.domain_name
  elasticsearch_version    = var.es_version

  # Comment out zone_awareness_enabled and zone_awareness_config for Dev 
  cluster_config {
    instance_type          = var.instance_type
    zone_awareness_enabled = true
    instance_count         = var.instance_count
    zone_awareness_config  {
        availability_zone_count = var.availability_zone_count
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_hr
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
    volume_type = var.volume_type
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
 

  log_publishing_options {
    enabled                  = true
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.lms_elasticsearch_log.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.lms_elasticsearch_log.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.lms_elasticsearch_log.arn
  }

  tags = {
    Name            = var.tag_domain
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "ElasticsearchDomain"
    Environment     = var.environment
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}


# Creating the AWS Elasticsearch domain policy
resource "aws_elasticsearch_domain_policy" "lms_es_domain_policy" {
  domain_name     = aws_elasticsearch_domain.lms_elasticsearch.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.lms_elasticsearch.arn}/*"
        }
    ]
}
POLICIES
}

#aws_iam_service_linked_role
resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}
