#!/bin/bash

STACK_NAME=bastion-poc
REGION=us-east-1
CLI_PROFILE=your-aws-profile-with-an-appropiate-role
EC2_INSTANCE_TYPE=t2.micro
KEY_NAME=your-key-pair-name

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy --region $REGION \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME \
    --template-file main.yml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE \
    KeyName=$KEY_NAME

# If the deploy succeeded, show the instances' IP address
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --region $REGION \
    --query "Exports[?ends_with(Name,'Ip')].Value"
fi
