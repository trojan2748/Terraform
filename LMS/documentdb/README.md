# LMS: DocumentDB Cluster

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Purpose](#purpose)
- [Deployment](#deployment)
  - [Deployment via CI/CD (preferred)](#deployment-via-cicd-preferred)
  - [Manual deployment via a terminal](#manual-deployment-via-a-terminal)
  - [Automated deployment notifications](#automated-deployment-notifications)
- [Provisioned Resources](#provisioned-resources)
- [Dependencies](#dependencies)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Purpose

This is a terraform module that creates the DocumentDB cluster used by the `LMS` `webhook` domain.

## Deployment

### Deployment via CI/CD (preferred)

Whenever possible, deploy this module via the [GitLabs CI/CD job](http://gl-gitlablv01/infrastructure/LMS/-/pipelines). Deployment instructions are:

1. Navigate to the [GitLabs CI/CD job](http://gl-gitlablv01/infrastructure/LMS/-/pipelines).
2. Click `Run Pipeline`.
3. The default branch is `master`. You should deploy from this branch unless you have pushed your changes into another branch.
4. In the Variables section, add a variable with the name of `ENV_PROJECT_PATH`. Then set the variable value to the path of the module you're deploying, assuming you're in repository root. For example, if you are deploying the `sales-domain`'s DocumentDB cluster, the value would be `sales-domain/documentdb`, because that is where it's located in the repository directory hierarchy.
5. Add a second variable with the name `ENV`, and the value of the environment you're deploying to. The valid environments are `prod`, `qa` and `uat`. (More may be added in the future.)

	![GitHub actions variable](./img/github_actions.jpg)

6. Click `Run pipeline`.
7. The pipeline will automatically progress until the `plan` step.  You'll have to manually trigger this step. After it completes, be sure you understand and agree to the proposed changes.
8. **Once you've read and understood the output from `terraform plan`**, you'll have to manually trigger the `apply` job. **Be sure you understand and agree to the changes listed in the plan step before you trigger this step**, as you won't be prompted again before terraform applies it.

### Manual deployment via a terminal

> **Warning:** 
> You must disconnect from the Cisco VPN when running these Makefile commands. Due to VPN limitations, this process will hang otherwise.
	
Occasionally, you'll need to manually deploy terraform code. This should *only* be done for debugging or emergency circumstances.

1. You'll first need to navigate to the module you're trying to deploy. (If you're deploying the sales-domain's `DocumentDB` module, for example, navigate to `sales-domain/documentdb`.
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

 
## Provisioned Resources

This terraform module provisions the following:

- A DocumentDB cluster for the `core` domain.
- A primary write instance for the `core` domain.
- Two secondary read instances for the `core` domain.
- A DocumentDB security group for use with the cluster.
- A KMS key for at-rest encryption of the DocumentDB data.
- A KMS key alias by which to reference the KMS key.

## Dependencies

This terraform module relies on the existence of the `username` and `password` credentials that will be assigned to the cluster. These credentials are automatically pulled from Parameter Store into the module:

- `/${var.environment}/documentdb/documentdb_username` for the username.
- `/${var.environment}/documentdb/documentdb_password` for the password.
