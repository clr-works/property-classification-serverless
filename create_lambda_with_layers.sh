#!/bin/bash

# Variables
BUCKET="ml-deployment-1753612051"
REGION="eu-west-1"
FUNCTION_NAME="predictPriceCategory"
ROLE_ARN="arn:aws:iam::942927113433:role/lambda-execution-role"

echo "Creating Lambda layer from S3..."

# Create single ML layer and capture ARN
ML_LAYER=$(aws lambda publish-layer-version \
  --layer-name ml-inference \
  --content S3Bucket=${BUCKET},S3Key=layers/ml-inference-layer.zip \
  --compatible-runtimes python3.10 \
  --query 'LayerVersionArn' \
  --output text)

echo "Layer ARN created:"
echo "ML Inference Layer: ${ML_LAYER}"

echo "Creating Lambda function with layer..."

# Create function with single layer
aws lambda create-function \
  --function-name ${FUNCTION_NAME} \
  --runtime python3.10 \
  --role ${ROLE_ARN} \
  --handler inference_lambda.lambda_handler \
  --code S3Bucket=${BUCKET},S3Key=deployment_package.zip \
  --timeout 30 \
  --memory-size 256 \
  --layers ${ML_LAYER} \
  --region ${REGION}

echo "Done! Lambda function created with ML layer."