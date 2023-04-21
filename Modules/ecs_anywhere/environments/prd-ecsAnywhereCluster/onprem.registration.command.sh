#!/bin/bash
# Copy this into a onprem server to added to and ECS Anywhere cluster
curl --proto "https" -o "/tmp/ecs-anywhere-install.sh" "https://amazon-ecs-agent.s3.amazonaws.com/ecs-anywhere-install-latest.sh" && bash /tmp/ecs-anywhere-install.sh --region "us-east-1" --cluster "prd-ecsAnywhereCluster" --activation-id "afc87802-e084-46d7-beb8-b2bfd531d24d" --activation-code "gc+4+SNE4DrcCP/e77Eq"
