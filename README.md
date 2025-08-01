# 🏠 Property Quality Classification — Serverless ML Deployment

This project demonstrates an end-to-end machine learning pipeline for **classifying housing prices into categories (low, medium, high)**, using a **serverless architecture** with **AWS Lambda**, **Docker**, and a modular project structure.

---

## Project Structure


---

## Key Features

-  Random Forest classifier to categorize property prices.
-  Preprocessing.
-  Dockerized Lambda function for serverless deployment.
-  Modular structure: clean separation of model, Lambda, and deployment logic.

---

## Setup & Usage

```bash
cd model
python model.py

curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -d '{"features": [1200, 3, 2, 0.5, "urban", ...]}'

# Example test payload
{
  "body": "{\"area\": 3000, \"bedrooms\": 3, \"bathrooms\": 2, \"stories\": 2, \"mainroad\": \"yes\", \"guestroom\": \"no\", \"basement\": \"yes\", \"hotwaterheating\": \"no\", \"airconditioning\": \"yes\", \"parking\": 2, \"prefarea\": \"yes\", \"furnishingstatus\": \"furnished\"}"
}

