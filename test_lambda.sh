#!/bin/bash

FUNCTION_NAME="predictPriceCategory"
REGION="eu-west-1"

echo "Testing Lambda function..."

# Invoke the function
aws lambda invoke \
  --function-name ${FUNCTION_NAME} \
  --region ${REGION} \
  --payload '{
    "body": "{\"area\": 3000, \"bedrooms\": 3, \"bathrooms\": 2, \"stories\": 2, \"mainroad\": \"yes\", \"guestroom\": \"no\", \"basement\": \"yes\", \"hotwaterheating\": \"no\", \"airconditioning\": \"yes\", \"parking\": 2, \"prefarea\": \"yes\", \"furnishingstatus\": \"furnished\"}"
  }' \
  response.json

echo "Lambda response:"
cat response.json

# Pretty print if jq is installed
if command -v jq &> /dev/null; then
    echo -e "\nPretty printed:"
    jq . response.json
fi

# Clean up
rm response.json