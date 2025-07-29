import pickle
import pandas as pd

# Load model and encoders
with open('price_classifier.pkl', 'rb') as f:
    model = pickle.load(f)

with open('encoders.pkl', 'rb') as f:
    encoders = pickle.load(f)

def preprocess_input(input_dict):
    """Prepare raw input into model-ready format"""
    df = pd.DataFrame([input_dict])

    # Encode categorical columns using saved encoders
    for col, le in encoders.items():
        df[col] = le.transform(df[col])

    return df

def predict_price_category(input_dict):
    X = preprocess_input(input_dict)
    prediction = model.predict(X)[0]
    return int(prediction)

# Example usage
if __name__ == "__main__":
    sample_input = {
        'area': 3000,
        'bedrooms': 3,
        'bathrooms': 2,
        'stories': 2,
        'mainroad': 'yes',
        'guestroom': 'no',
        'basement': 'yes',
        'hotwaterheating': 'no',
        'airconditioning': 'yes',
        'parking': 2,
        'prefarea': 'yes',
        'furnishingstatus': 'furnished'
    }

    pred = predict_price_category(sample_input)
    print("Predicted category:", pred)  # Output will be 0, 1, or 2
