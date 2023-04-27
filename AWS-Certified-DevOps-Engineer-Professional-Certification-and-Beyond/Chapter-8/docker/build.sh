#!/bin/bash
set -x
DOCKER_REGISTRY=362387340557.dkr.ecr.us-east-1.amazonaws.com

DNS_NAME=$(jq -r '.dnsName' cicd.json)
GROUP=$(jq -r '.group' cicd.json | sed 's:/*$::')
REPO=$GROUP"/"$DNS_NAME
REPO_NAME=$(echo "$REPO" | tr '[:upper:]' '[:lower:]')

echo "# Checking to see if $REPO_NAME exist #"
aws ecr describe-repositories --repository-names $REPO_NAME 2>&1 > /dev/null
status=$?
if [[ ! "${status}" -eq 0 ]]; then
    aws ecr create-repository --repository-name $REPO_NAME
    # Set Repository Policy
    aws ecr set-repository-policy \
    --repository-name $REPO_NAME \
    --policy-text '{"Version":"2008-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":["arn:aws:iam::369357936615:root","arn:aws:iam::418300104773:root"]},"Action":["ecr:GetDownloadUrlForLayer","ecr:BatchGetImage","ecr:BatchCheckLayerAvailability","ecr:PutImage","ecr:InitiateLayerUpload","ecr:UploadLayerPart","ecr:CompleteLayerUpload"]}]}'
fi

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS  --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

docker build -t $REPO_NAME . 
docker tag $REPO_NAME $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$REPO_NAME
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$REPO_NAME
