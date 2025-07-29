#!/bin/bash

# Configuration
REGION="eu-west-1"
ACCOUNT_ID="942927113433"
REPO_NAME="ml-lambda-inference"
FUNCTION_NAME="predictPriceCategory"
ROLE_ARN="arn:aws:iam::942927113433:role/lambda-execution-role"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Creating Lambda function from container image..."

# Check if function exists and delete it
if aws lambda get-function --function-name ${FUNCTION_NAME} --region ${REGION} 2>/dev/null; then
    echo "Function exists. Deleting..."
    aws lambda delete-function \
        --function-name ${FUNCTION_NAME} \
        --region ${REGION}
    sleep 5
fi

# Create Lambda function from container
echo "Creating Lambda function..."
aws lambda create-function \
    --function-name ${FUNCTION_NAME} \
    --package-type Image \
    --code ImageUri=${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest \
    --role ${ROLE_ARN} \
    --timeout 30 \
    --memory-size 512 \
    --environment Variables={PYTHONPATH=/var/task} \
    --region ${REGION}

# Wait for function to be active
echo "Waiting for function to be active..."
aws lambda wait function-active \
    --function-name ${FUNCTION_NAME} \
    --region ${REGION}

echo -e "${GREEN}✅ Lambda function created successfully!${NC}"
echo "Function ARN: arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}"