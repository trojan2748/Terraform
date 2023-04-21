#!/usr/bin/env bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\",\"logentries\",\"none\"]  >> /etc/ecs/ecs.config
