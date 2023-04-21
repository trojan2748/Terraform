#!/bin/bash
# Copy this into a onprem server to added to and ECS Anywhere cluster
curl --proto "https" -o "/tmp/ecs-anywhere-install.sh" "https://amazon-ecs-agent.s3.amazonaws.com/ecs-anywhere-install-latest.sh" && bash /tmp/ecs-anywhere-install.sh --region "${region}" --cluster "${cluster}" --activation-id "${id}" --activation-code "${code}"
