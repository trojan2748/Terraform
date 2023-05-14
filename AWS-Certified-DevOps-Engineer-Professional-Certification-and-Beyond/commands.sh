##################
# Cloudformation #
##################
aws cloudformation deploy \
    --template-file sqs-queues.yml \
    --stack-name Chapt7-sqs \
    --parameter-overrides AlarmEmail=adam@test.com QueueName=chapter7

aws cloudformation create-change-set \
    --stack-name Chapt7-sqs \
    --template-body file://sqs-queues_change_set.yml \
    --change-set-name Chapt7-sqs-lambda \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=AlarmEmail,ParameterValue=adam@test.com ParameterKey=QueueName,ParameterValue=chapter7

aws cloudformation package \
    --template-file nested_dynamo.yml \
    --s3-bucket adamll3 \
    --output-template-file packed_template.yml

aws cloudformation deploy \
    --template-file /home/adam.landas/personal/Terraform/AWS-Certified-DevOps-Engineer-Professional-Certification-and-Beyond/Chapter-7/nested/packed_template.yml \
    --stack-name Chap7-nested \
    --capabilities CAPABILITY_IAM

aws cloudformation delete-stack \
    --stack-name Chap7-nested
