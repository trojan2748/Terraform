<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Purpose](#purpose)
- [Scope](#scope)
- [Resources](#resources)
- [Terraform plan output](#terraform-plan-output)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Purpose

Provisions an ECS cluster, the services running within that cluster, and other supporting resources (ALB's, listeners, etc).

# Scope

This module includes ecs cluster configuration for both the E-platform ECS cluster, and the legacy ECS cluster. (The legacy ECS cluster is the one that powers `pr1-services` / `qa1-services`.) It can provisions these clusters in `uat`, `qa`, or `prod`.

The desired application / environment can be configured via command line invocation. I.e. to deploy the E-platform cluster to `uat`, you'd use the following command: `ENV=uat-eplatform`.

# Resources
