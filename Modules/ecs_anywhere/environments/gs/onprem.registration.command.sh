#!/bin/bash
# Copy this into a onprem server to added to and ECS Anywhere cluster
curl --proto "https" -o "/tmp/ecs-anywhere-install.sh" "https://amazon-ecs-agent.s3.amazonaws.com/ecs-anywhere-install-latest.sh" && bash /tmp/ecs-anywhere-install.sh --region "us-east-1" --cluster "gs-ecsAnywhereCluster" --activation-id "08e878f9-a0bb-43bc-8456-f80a91bf33ef" --activation-code "EN3aA5FKyp/cHNjVWWBx"
