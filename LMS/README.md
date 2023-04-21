# LMS(Lab Management System)
LMS

# Overview

This repository holds Terraform scripts used to provision LMS infrastructure resources in all environments i.e Dev, QA, UAT and Prod .

## High-level module organization:

This repo contains the following standalone Terrform modules:

- **vpc-resource**- The `vpc-resources` module provisions all the basic networking components used for LMS purposes. This includes the VPC itself, subnets, nat components, etc.
- **ecs-cluster**- The `ecs-cluster` module provisions the cluster that is used by LMS(Lab Management System), as well as related resources (load balancers, etc).

## Environments

Each module contains an `environments` folder, which in turn has subdirectories for all the environments that can be used with the module. These `environment` directories set any environment-specific values, which are then passed up to a common terraform module in the root of the module.

## Deployment

### Deployment via CI/CD (preferred)

Whenever possible, deploy this module via the [GitLabs CI/CD job](http://gl-gitlablv01/infrastructure/LMS/-/pipelines). Deployment instructions are:

1. Navigate to the [GitLabs CI/CD job](http://gl-gitlablv01/infrastructure/LMS/-/pipelines).
2. Click `Run Pipeline`.
3. The default branch is `master`. You should deploy from this branch unless you have pushed your changes into another branch.
4. In the Variables section, add a variable with the name of `ENV_PROJECT_PATH`. Then set the variable value to the path of the module you're deploying, assuming you're in repository root. For example, if you are deploying the DocumentDB cluster, the value would be `documentdb`, because that is where it's located in the repository directory hierarchy.
5. Add a second variable with the name `ENV`, and the value of the environment you're deploying to. The valid environments are `prod`, `qa` and `uat`. (More may be added in the future.)

	![GitHub actions variable](./img/github_actions.jpg)

6. Click `Run pipeline`.
7. The pipeline will automatically progress until the `plan` step.  You'll have to manually trigger this step. After it completes, be sure you understand and agree to the proposed changes.
8. **Once you've read and understood the output from `terraform plan`**, you'll have to manually trigger the `apply` job. **Be sure you understand and agree to the changes listed in the plan step before you trigger this step**, as you won't be prompted again before terraform applies it.

### Manual deployment via a terminal

> **Warning:** 
> You must disconnect from the Cisco VPN when running these Makefile commands. Due to VPN limitations, this process will hang otherwise.
	
Occasionally, you'll need to manually deploy terraform code. This should *only* be done for debugging or emergency circumstances.

1. You'll first need to navigate to the module you're trying to deploy. (If you're deploying the DocumentDB module, for example, navigate to `documentdb`.
2. Make sure you have a valid SSO token exported in your terminal.
3. Type the following, based on your platform...

**Mac / Linux users:**
	
	ENV=<dev | qa | prod> make apply
	
	
**Windows users**
	
	
	./Makefile.ps1 terraform apply <dev | qa | prod>
		

### Automated deployment notifications

The Makefile used in this project automatically sends deployment update notifications to the Microsoft Teams deployment channels. These are the `Deployments PR-1` channel and the `Deployments QA-1` channel.

> **Warning:** 
> You must disconnect from the Cisco VPN when running these Makefile commands. Due to VPN limitations, this process will hang otherwise.

