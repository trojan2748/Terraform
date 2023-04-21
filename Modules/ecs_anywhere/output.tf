output "ssm_activation" {
    value = [aws_ssm_activation.ssm_activiation.id, aws_ssm_activation.ssm_activiation.activation_code]
}

data "template_file" "tmp_ssm_activation" {
    template = file("${path.module}/ssm-activation.json.tpl")

    vars = {
        id      = aws_ssm_activation.ssm_activiation.id
        code    = aws_ssm_activation.ssm_activiation.activation_code
    }
}

data "template_file" "bash_activation_command" {
    template = file("${path.module}/onprem.registration.command.sh.tpl")

   vars = {
        id      = aws_ssm_activation.ssm_activiation.id
        code    = aws_ssm_activation.ssm_activiation.activation_code
        cluster = "${var.env}-ecsAnywhereCluster"
        region  = "${var.aws_region}"
    }
}

resource "local_file" "ssm_activation_file" {
    content  = "${data.template_file.tmp_ssm_activation.rendered}"
    filename = "ssm_activation.json"
}

resource "local_file" "bash_activation_file" {
    content  = "${data.template_file.bash_activation_command.rendered}"
    filename = "onprem.registration.command.sh"
}

