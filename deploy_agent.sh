#!/bin/bash
# Agent deployment to AgentCore Runtime

set -e

# Load infrastructure configuration
source infrastructure.env

# Install dependencies
# pip install strands-agents strands-agents-tools bedrock-agentcore-starter-toolkit boto3

# Configure agent with VPC settings
uv run agentcore configure \
    --entrypoint src/agent.py \
    --name calculator_agent \
    --region $REGION \
    --execution-role $EXECUTION_ROLE_ARN \
    --vpc \
    --subnets $PRIVATE_SUBNET_1_ID,$PRIVATE_SUBNET_2_ID \
    --security-groups $SECURITY_GROUP_ID \
    --disable-memory \
    --non-interactive

# Launch agent to AgentCore Runtime
uv run agentcore launch

echo "Agent deployment complete!"
