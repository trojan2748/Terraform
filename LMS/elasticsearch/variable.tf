variable "environment" {
  type    = string
  default = ""

}

variable "domain_name" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "tag_domain" {
  type    = string
  default = ""
}

variable "ebs_volume_size" {
  type    = string
  default = ""
}

variable "es_version" {
  type    = string
  default = ""
}

variable "create" {
  type    = string
  default = true
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]

}

variable "allowed_cidr_blocks" {
  type    = string
  default = ""

}

variable "volume_type" {
  type    = string
  default = ""

}

variable "ingress_port_range_start" {
  type    = string
  default = ""

}

variable "ingress_port_range_end" {
  type    = string
  default = ""

}

variable "log_group_name" {
  type    = string
  default = ""

}

variable "cloudwatch_es_policy" {
  type    = string
  default = ""

}

variable "log_stream_name" {
  type    = string
  default = ""

}

variable "tags" {
  type    = string
  default = ""

}

variable "elasticsearch_version" {
  type    = string
  default = ""

}

variable "instance_count" {
  type    = string
  default = ""

}

variable "automated_snapshot_hr" {
  type    = string
  default = ""

}

variable "Domain" {
  type    = string
  default = ""

}

variable "security_group_ids" {}
variable "availability_zone_count" {}