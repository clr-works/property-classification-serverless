#!/bin/bash

# Your S3 bucket
BUCKET="ml-deployment-1753612051"

# Single layer with proper cleanup
echo "Building ML layer with numpy, scipy, and scikit-learn..."
mkdir -p ml-layer/python

# Install dependencies
pip install scikit-learn==1.3.0 -t ml-layer/python/

# IMPORTANT: Remove test directories that cause import issues
find ml-layer -type d -name "tests" -exec rm -rf {} + 2>/dev/null || true
find ml-layer -type d -name "test" -exec rm -rf {} + 2>/dev/null || true
find ml-layer -type d -name "*test*" -exec rm -rf {} + 2>/dev/null || true
find ml-layer -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find ml-layer -name "*.pyc" -delete
find ml-layer -name "*.pyo" -delete

# Remove numpy test modules specifically
rm -rf ml-layer/python/numpy/tests
rm -rf ml-layer/python/numpy/*/tests
rm -rf ml-layer/python/numpy/*/test*
rm -rf ml-layer/python/numpy/_core/tests

# Create zip
cd ml-layer && zip -r ../ml-inference-layer.zip . && cd ..
rm -rf ml-layer

# Upload to S3
echo "Uploading layer to S3..."
aws s3 cp ml-inference-layer.zip s3://${BUCKET}/layers/

# Clean up
rm -f ml-inference-layer.zip

echo "Done! Cleaned ML layer uploaded"

# Now update the layer version
echo "Publishing new layer version..."
aws lambda publish-layer-version \
  --layer-name ml-inference \
  --content S3Bucket=${BUCKET},S3Key=layers/ml-inference-layer.zip \
  --compatible-runtimes python3.10 \
  --region eu-west-1

echo "Update your Lambda to use the new layer version!"