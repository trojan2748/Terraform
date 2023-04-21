## Purpose

This is a terraform configration that creates the Virtual Private Cloud and its components used by the LMS application.

## Quickstart

To perform terraform plan in a particular environment, type: 

cd /environments/sub-directory and run terraform plan

To perform terraform apply in a particular environment, type: 

cd /environments/sub-directory and run terraform apply

## Resources

This terraform module provisions the following resources:

- VPC 
- Subnet
- Nat Gateway
- Elastic IP
- Network Route
- Network Route Table Association
- Route Table
- Internet Gateway

## External dependencies:

- `tgw-0e26202f433921c98`: this transit gateway must already exist. After the terraform module is provisioned, you'll have to allow access from the transit gateway to complete the setup.
