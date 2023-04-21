/*
resource "datadog_monitor" "cpu_monitor" {
  name               = "Infra alert: High CPU usage on the AmazonMQ ${var.broker_name} broker"
  type               = "metric alert"
  message            = "CPU is high on the ${var.broker_name} AmazonMQ cluster in ${var.environment} Notify: @SRETeam@glidewelldental.com"
  escalation_message = "Escalation message @teams-ProductionMonitoring-DataDog-Miscellaneous"

  query = "avg(last_1m):avg:aws.amazonmq.cpuutilization{name:${var.broker_name}} by {host} > 10"

  monitor_thresholds {
    warning  = 8
    critical = 10
  }

  include_tags = true

  tags = ["team:SRE"]
}

resource "datadog_monitor" "memory_monitor" {
  name               = "Infra alert: High Memory usage on the ECS ${var.broker_name} cluster"
  type               = "metric alert"
  message            = "Memory is high on the ${var.broker_name} AmazonMQ broker in ${var.environment} Notify: @SRETeam@glidewelldental.com"
  escalation_message = "Escalation message @teams-ProductionMonitoring-DataDog-Miscellaneous"
  query = "avg(last_1m):avg:aws.ecs.cluster.memory_utilization{brokername:${var.broker_name}} by {host} > 5"

  monitor_thresholds {
    warning  = 3
    critical = 5
  }

  include_tags = true
  tags = ["team:SRE"]
}

*/