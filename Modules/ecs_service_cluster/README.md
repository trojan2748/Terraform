# Module: ecs_service_cluster
This will create the main cluster for our ECS/EC2 services

## Dependencies
This module can be run by itself

## Usage
```
$ cd environments
$ cp -r template NEW_ENV
$ vim NEW_ENV/template.tf
$ terraform plan
```

## Creates
  - 5 x aws_route_table_association
  - 5 x aws_subnet
  - 3 x aws_iam_role_policy_attachment
  - 2 x aws_route_table
  - 1 x aws_ecs_cluster
  - 1 x aws_eip
  - 1 x aws_iam_instance_profile
  - 1 x aws_iam_role
  - 1 x aws_internet_gateway
  - 1 x aws_launch_configuration
  - 1 x aws_security_group
  - 1 x aws_vpc
  - 1 x aws_autoscaling_group
  - 1 x aws_nat_gateway

```
 Name                                                                                 Monthly Qty  Unit              Monthly Cost

 module.ecs_service_cluster.aws_autoscaling_group.ecs_service_cluster_asg
 └─ module.ecs_service_cluster.aws_launch_configuration.ecs_service_launch_config
    ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)                                     1,460  hours                   $16.94
    ├─ EC2 detailed monitoring                                                                 14  metrics                  $4.20
    └─ root_block_device
       └─ Storage (general purpose SSD, gp2)                                                   16  GB                       $1.60

 module.ecs_service_cluster.aws_nat_gateway.ecs_private_nat_gw
 ├─ NAT gateway                                                                               730  hours                   $32.85
 └─ Data processed                                                                 Monthly cost depends on usage: $0.045 per GB
 OVERALL TOTAL                                                                                                             $55.59
```

