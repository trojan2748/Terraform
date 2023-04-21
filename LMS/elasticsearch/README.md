## Purpose

This is a terraform configration that creates the ElasticSearch Domain used by the E-Platform application.

## Quickstart

To perform terraform plan in a particular environment, type: 

cd /environments/sub-directory  and run terraform plan

To perform terraform apply in a particular environment, type: 

cd /environments/sub-directory  and run terraform apply

## Resources

This terraform module provisions the following resources:

- Elasticsearch Domain
- Elasticsearch Domain Policy
- Security Group / Security Group Rule
- Cloudwatch Log Group
- Cloudwatch Log Stream
