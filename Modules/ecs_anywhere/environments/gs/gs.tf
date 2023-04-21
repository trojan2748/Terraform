###########################
# S3 remote state backend #
###########################
terraform {
    backend "s3" {
        bucket = "gd-tf-backend"
        key    = "project/gs/gs-ecsanywhere"
        region = "us-east-1"
    }
}


##########
# Module #
##########

module "ecsanywhere" {
    env     = "gs"
    source  = "../.."
}


##################
# Module outputs #
##################
#output "ssm_activation" {
#    description = "SSM Activation ID and code (Good for 24 hours after createtion)"
#    value       = module.ecsanywhere.ssm_activation.activation_code
#}

#output "" {
#    description = ""
#    value       = module.ecsanywhere.
#}

#output "" {
#    description = ""
#    value       = module.ecsanywhere.
#}

