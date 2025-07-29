#!/bin/bash

# Configuration
REGION="eu-west-1"
ACCOUNT_ID="942927113433"
FUNCTION_NAME="predictPriceCategory"
API_NAME="HousePricePredictionAPI"
STAGE_NAME="prod"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Creating API Gateway..."

# Create REST API
API_ID=$(aws apigateway create-rest-api \
    --name ${API_NAME} \
    --description "API for house price prediction ML model" \
    --endpoint-configuration types=REGIONAL \
    --region ${REGION} \
    --query 'id' \
    --output text)

echo "Created API with ID: ${API_ID}"

# Get root resource ID
ROOT_ID=$(aws apigateway get-resources \
    --rest-api-id ${API_ID} \
    --region ${REGION} \
    --query 'items[0].id' \
    --output text)

# Create /predict resource
RESOURCE_ID=$(aws apigateway create-resource \
    --rest-api-id ${API_ID} \
    --parent-id ${ROOT_ID} \
    --path-part predict \
    --region ${REGION} \
    --query 'id' \
    --output text)

echo "Created /predict resource"

# Create POST method
aws apigateway put-method \
    --rest-api-id ${API_ID} \
    --resource-id ${RESOURCE_ID} \
    --http-method POST \
    --authorization-type NONE \
    --region ${REGION}

# Create Lambda integration
LAMBDA_URI="arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}/invocations"

aws apigateway put-integration \
    --rest-api-id ${API_ID} \
    --resource-id ${RESOURCE_ID} \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri ${LAMBDA_URI} \
    --region ${REGION}

# Set up method response
aws apigateway put-method-response \
    --rest-api-id ${API_ID} \
    --resource-id ${RESOURCE_ID} \
    --http-method POST \
    --status-code 200 \
    --response-models '{"application/json":"Empty"}' \
    --region ${REGION}

# Add Lambda permission for API Gateway
aws lambda add-permission \
    --function-name ${FUNCTION_NAME} \
    --statement-id apigateway-invoke \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/*" \
    --region ${REGION} 2>/dev/null || true

# Deploy API
echo "Deploying API..."
    --rest-api-id ${API_ID} \
    --stage-name ${STAGE_NAME} \
    --region ${REGION}

# Get the invoke URL
INVOKE_URL="https://${API_ID}.execute-api.${REGION}.amazonaws.com/${STAGE_NAME}/predict"

echo -e "\n${GREEN}✅ API Gateway created successfully!${NC}"
echo -e "${YELLOW}API Endpoint:${NC} ${INVOKE_URL}"
echo -e "\n${YELLOW}Test with:${NC}"
echo "curl -X POST ${INVOKE_URL} \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"area\": 3000, \"bedrooms\": 3, \"bathrooms\": 2, \"stories\": 2, \"mainroad\": \"yes\", \"guestroom\": \"no\", \"basement\": \"yes\", \"hotwaterheating\": \"no\", \"airconditioning\": \"yes\", \"parking\": 2, \"prefarea\": \"yes\", \"furnishingstatus\": \"furnished\"}'"