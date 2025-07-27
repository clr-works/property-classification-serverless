# inference_lambda.py - Minimal dependencies version
import json
import pickle
import numpy as np


def lambda_handler(event, context):
    # Load model and encoders
    with open('price_classifier.pkl', 'rb') as f:
        clf = pickle.load(f)

    with open('encoders.pkl', 'rb') as f:
        encoders = pickle.load(f)

    # Parse input - expecting a dictionary of features
    body = json.loads(event['body'])

    # Manual encoding without pandas/sklearn
    features = []
    feature_names = ['area', 'bedrooms', 'bathrooms', 'stories', 'mainroad',
                     'guestroom', 'basement', 'hotwaterheating', 'airconditioning',
                     'parking', 'prefarea', 'furnishingstatus']

    for feat in feature_names:
        value = body.get(feat)
        if feat in encoders:
            # For categorical features
            encoder_classes = list(encoders[feat].classes_)
            if value in encoder_classes:
                encoded_value = encoder_classes.index(value)
            else:
                encoded_value = 0  # default
        else:
            # For numeric features
            encoded_value = float(value)
        features.append(encoded_value)

    # Convert to numpy array for prediction
    X = np.array([features])

    # Predict
    prediction = clf.predict(X)[0]

    # Map back to category names
    categories = ['high', 'low', 'medium']  # based on your label encoding

    return {
        'statusCode': 200,
        'body': json.dumps({
            'price_category': categories[int(prediction)]
        })
    }
