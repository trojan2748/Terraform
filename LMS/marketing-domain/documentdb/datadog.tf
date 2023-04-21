/*

resource "datadog_monitor" "cpu_monitor" {
  
  for_each           = var.create ? var.cluster_details : {}
  name               = "Infra alert: High CPU usage on the DocumentDB ${each.value["identifier"]} cluster in ${var.environment}"
  type               = "metric alert"
  message            = "CPU is high on the ${each.value["identifier"]} DocumentDB Sales cluster in ${var.environment} Notify: @sreteam@glidewelldental.com"
  escalation_message = "Escalation message @teams-ProductionMonitoring-DataDog-Miscellaneous"

  query = "avg(last_1m):avg:aws.docdb.cpuutilization{clustername:${each.value["identifier"]}} by {host} > 10"

  monitor_thresholds {
    warning  = 8
    critical = 10
  }

  include_tags = true
  tags = ["team:SRE"]
}

resource "datadog_monitor" "memory_monitor" {

  for_each           = var.create ? var.cluster_details : {}
  name               = "Infra alert: High memory usage on the DocumentDB ${each.value["identifier"]} cluster in ${var.environment}"
  type               = "metric alert"
  message            = "Memory is high on the ${each.value["identifier"]} DocumentDB Sales cluster in ${var.environment} Notify: @sreteam@glidewelldental.com"
  escalation_message = "Escalation message @teams-ProductionMonitoring-DataDog-Miscellaneous"

  query = "avg(last_1m):avg:aws.docdb.freeable_memory.maximum{clustername:${each.value["identifier"]}} by {host} > 10"

  monitor_thresholds {
    warning  = 8
    critical = 10
  }

  include_tags = true
  tags = ["team:SRE"]
}

*/
