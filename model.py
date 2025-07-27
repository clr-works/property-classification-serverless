import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.preprocessing import LabelEncoder
import pickle

# Load the data
df = pd.read_csv('Housing.csv')

# Create price categories using fixed bins instead of quantiles
df['price_category'] = pd.cut(
    df['price'],
    bins=[0, 4_000_000, 7_000_000, df['price'].max()],
    labels=['low', 'medium', 'high']
)

# Encode categorical variables
categorical_cols = df.select_dtypes(include='object').columns
encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    encoders[col] = le  # Save for possible decoding later

# Encode the price_category labels
df['price_category'] = df['price_category'].astype(str)
df['price_category'] = LabelEncoder().fit_transform(df['price_category'])

# Optional: Check distribution of price per category
print(df.groupby('price_category')['price'].describe())

# Split into features and labels
X = df.drop(columns=['price', 'price_category'])
y = df['price_category']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Class distribution
print("Class distribution:\n", y_train.value_counts())

# Train a model with class balancing
clf = RandomForestClassifier(random_state=42, class_weight='balanced')
clf.fit(X_train, y_train)

# Evaluate
y_pred = clf.predict(X_test)
print(classification_report(y_test, y_pred))

# Save the trained model
with open('price_classifier.pkl', 'wb') as f:
    pickle.dump(clf, f)

# Save the encoders too if needed for inference
with open('encoders.pkl', 'wb') as f:
    pickle.dump(encoders, f)






