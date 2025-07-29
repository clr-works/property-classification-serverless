#!/bin/bash

# Configuration
REGION="eu-west-1"
ACCOUNT_ID="942927113433"
REPO_NAME="ml-lambda-inference"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Starting deployment process..."

# Check if ECR repository exists
if aws ecr describe-repositories --repository-names ${REPO_NAME} --region ${REGION} 2>/dev/null; then
    echo "✅ ECR repository already exists"
else
    echo "Creating ECR repository..."
    aws ecr create-repository \
        --repository-name ${REPO_NAME} \
        --region ${REGION}
fi

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region ${REGION} | \
    docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# Build image
echo "Building Docker image..."
docker build -t ${REPO_NAME} .

# Tag image
echo "Tagging image..."
docker tag ${REPO_NAME}:latest \
    ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest

# Push image
echo "Pushing image to ECR..."
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest

echo -e "${GREEN}✅ Image successfully pushed to ECR!${NC}"