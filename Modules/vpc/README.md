# Module: network
This will create VPC, Subnet, and associated routing

## Dependencies
This module is standalone and can be run by itself.

## Usage
Environments are run as modules:
```
$ cd environments/
$ mkdir <NEW_ENV>
$ cp -r test <NEW_ENV>
Edit test.tf and update variables
$ terraform init
$ terraform apply
```

## Creates
  - 20 x aws_route_table_association
  - 20 x aws_subnet
  - 2 x aws_route_table
  - 1 x aws_eip
  - 1 x aws_internet_gateway
  - 1 x aws_vpc
  - 1 x aws_vpc_dhcp_options
  - 1 x aws_vpc_dhcp_options_association
  - 1 x aws_nat_gateway

## Cost breakdown
```
 Name                                   Monthly Qty  Unit              Monthly Cost
 aws_nat_gateway.ecs_private_nat_gw
 ├─ NAT gateway                                 730  hours                   $32.85
 └─ Data processed                   Monthly cost depends on usage: $0.045 per GB

 OVERALL TOTAL                                                               $32.85
```
