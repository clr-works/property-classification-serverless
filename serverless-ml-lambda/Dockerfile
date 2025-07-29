FROM public.ecr.aws/lambda/python:3.10

# Install specific versions
RUN pip install \
    scikit-learn==1.7.1 \
    pandas==2.1.2 \
    scipy==1.9.0

# Copy function code
COPY lambda/inference_lambda.py ${LAMBDA_TASK_ROOT}

# Copy model files
COPY model/price_classifier.pkl ${LAMBDA_TASK_ROOT}
COPY model/encoders.pkl ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler
CMD ["inference_lambda.lambda_handler"]