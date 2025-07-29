import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
df = pd.read_csv('Housing.csv')

# Print basic info
print("📌 Dataset Overview")
print(df.head())
print("\n✅ Info:")
print(df.info())
print("\n📊 Description:")
print(df.describe(include='all'))

# Check for missing values
print("\n❓ Missing values:")
print(df.isnull().sum())

# Encode categorical features for correlation heatmap (temporary)
df_encoded = df.copy()
categorical = ['mainroad', 'guestroom', 'basement', 'hotwaterheating',
               'airconditioning', 'prefarea', 'furnishingstatus']
df_encoded[categorical] = df_encoded[categorical].apply(lambda x: x.astype('category').cat.codes)

plt.figure(figsize=(10, 6))
sns.heatmap(df_encoded.corr(), annot=True, cmap='coolwarm', annot_kws={'size': 8})
plt.title('🔍 Feature Correlation Heatmap', fontsize=14)
plt.xticks(rotation=45, ha='right', fontsize=9)
plt.yticks(rotation=0, fontsize=9)
plt.tight_layout()
plt.show()

# Distribution plots for numerical features
numerical = ['price', 'area', 'bedrooms', 'bathrooms', 'stories', 'parking']
for col in numerical:
    plt.figure()
    sns.histplot(df[col])
    plt.title(f'Distribution of {col}')
    plt.show()

# Boxplots to check for outliers
for col in numerical:
    plt.figure()
    sns.boxplot(x=df[col])
    plt.title(f'Boxplot of {col}')
    plt.show()

# Countplots for categorical variables
for col in categorical:
    plt.figure()
    sns.countplot(x=df[col])
    plt.title(f'Frequency of {col}')
    plt.xticks(rotation=45)
    plt.show()
