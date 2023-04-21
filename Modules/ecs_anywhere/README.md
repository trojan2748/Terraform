# Module: ecsanywhere
This module will create an ECS Anywhere cluster and generate the bash snippet

to register on prem servers

## Creates
  - 3 x aws_iam_role_policy_attachment
  - 2 x aws_iam_role
  - 1 x aws_ecs_cluster
  - 1 x aws_ssm_activation

## Notes
ECSAnywhere clusters do not need the following:
- VPCs
- ALBs
- Listeners
- Target groups


## Usage
Environments are run as modules:
```
$ cd environments/
$ mkdir <NEW_ENV>
$ cp -r template <NEW_ENV>
Edit template.tf and update variables
$ terraform init
$ terraform apply
```

## Recreate onprem host registration command:
SSM activation codes expire every 24 hours. Below will regenerate an activation

code and recreate the onprem script.
```
$ cd environments/$ENV/
$ terraform destroy -target module.ecsanywhere.aws_ssm_activation.ssm_activiation
$ terrafrom apply
```
