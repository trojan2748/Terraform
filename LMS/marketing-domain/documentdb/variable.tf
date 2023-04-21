########################
# Security Group
########################
variable "ingress_cidr_blocks" {}

########################
# DocumentDB Cluster
########################

variable "port" {}
variable "deletion_protection" {}
variable "enabled_cloudwatch_logs_exports" {}
variable "preferred_backup_window" {}
variable "preferred_maintenance_window" {}
variable "storage_encrypted" {}
variable "skip_final_snapshot" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "domain" {}
variable "vpc_security_group_ids" {}
variable "db_subnet_group_name" {}
variable "source_docdb_ingress_rules" {}
variable "docdb_sg_ingress_rules" {}
variable "lms-asg-sg" {}
variable "lms-alb-sg" {}

variable "create" {
  type    = string
  default = true
}

variable "instance_class" {
    type = string
    default = ""
  
}

########################
# KMS
########################

variable "key_alias" {}

########################
# Tags
########################

variable "environment" {}
variable "resource_version" {}
variable "instance_count" {}

/*
variable "cluster_names" {
  description = "Name of all the documentDB cLuster"
  type        = set(string)
  default     = [ "ep-prod-east-bridge","ep-prod-east-core", "ep-prod-east-crm" , "ep-prod-east-finance", "ep-prod-east-sales", "ep-prod-east-webhook" ]
}
*/

variable "cluster_details" {

      type = map(object({
        engine_version          = string
        engine                  = string
        backup_retention_period = number
        identifier              = string
        

    
      }))  

      default = {
  
        "lms-east-marketing" = {
          engine_version = "4.0.0"
          engine         = "docdb"
          backup_retention_period = 5
          identifier     = "east-marketing"
         

      
        }

      } 
}

variable "env" {
    type = string 
    default = ""
} 
