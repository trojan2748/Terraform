##########
# Module #
##########

module "ecsanywhere" {
    env     = "prd"
    source  = "../.."
}


##################
# Module outputs #
##################
#output "ssm_activation" {
#    description = "SSM Activation ID and code (Good for 24 hours after createtion)"
#    value       = module.ecsanywhere.aws_ssm_activation.ssm_activiation.activation_code
#}

#output "" {
#    description = ""
#    value       = module.ecsanywhere.
#}

#output "" {
#    description = ""
#    value       = module.ecsanywhere.
#}

