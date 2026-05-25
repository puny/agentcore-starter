#!/bin/bash
# cleanup.sh

source infrastructure.env

# Delete AgentCore Runtime
uv run agentcore delete --non-interactive

# Delete NAT Gateway
aws ec2 delete-nat-gateway --nat-gateway-id $NAT_GATEWAY_ID --region $REGION
aws ec2 wait nat-gateway-deleted --nat-gateway-ids $NAT_GATEWAY_ID --region $REGION

# Release Elastic IP
EIP_ALLOC_ID=$(aws ec2 describe-addresses --region $REGION \
    --filters "Name=tag:Project,Values=$PROJECT_NAME" \
    --query 'Addresses[0].AllocationId' --output text)
aws ec2 release-address --allocation-id $EIP_ALLOC_ID --region $REGION

# Delete remaining resources
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION
aws ec2 delete-subnet --subnet-id $PUBLIC_SUBNET_ID --region $REGION
aws ec2 delete-subnet --subnet-id $PRIVATE_SUBNET_1_ID --region $REGION
aws ec2 delete-subnet --subnet-id $PRIVATE_SUBNET_2_ID --region $REGION
aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID --region $REGION
aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION

# Delete IAM role
ROLE_NAME="$PROJECT_NAME-agentcore-execution-role"
aws iam detach-role-policy --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonBedrockFullAccess
aws iam detach-role-policy --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
aws iam delete-role --role-name $ROLE_NAME --region $REGION

# rm -f infrastructure.env
