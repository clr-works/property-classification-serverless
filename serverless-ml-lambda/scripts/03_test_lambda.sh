#!/bin/bash

# Configuration
FUNCTION_NAME="predictPriceCategory"
REGION="eu-west-1"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "Testing Lambda function..."

# Create test payload
cat > /tmp/test_payload.json << 'EOF'
{
  "body": "{\"area\": 3000, \"bedrooms\": 3, \"bathrooms\": 2, \"stories\": 2, \"mainroad\": \"yes\", \"guestroom\": \"no\", \"basement\": \"yes\", \"hotwaterheating\": \"no\", \"airconditioning\": \"yes\", \"parking\": 2, \"prefarea\": \"yes\", \"furnishingstatus\": \"furnished\"}"
}
EOF

# Invoke Lambda
echo "Sending test request..."
aws lambda invoke \
    --function-name ${FUNCTION_NAME} \
    --region ${REGION} \
    --payload file:///tmp/test_payload.json \
    /tmp/response.json

# Check if invocation was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Invocation successful!${NC}"

    # Display response
    echo -e "\n${YELLOW}Response:${NC}"
    cat /tmp/response.json | jq '.' 2>/dev/null || cat /tmp/response.json

    # Check for errors in response
    if grep -q "errorMessage" /tmp/response.json; then
        echo -e "\n${RED}❌ Function returned an error${NC}"
        exit 1
    else
        echo -e "\n${GREEN}✅ Test passed!${NC}"
    fi
else
    echo -e "${RED}❌ Failed to invoke function${NC}"
    exit 1
fi

# Cleanup
rm -f /tmp/test_payload.json /tmp/response.json