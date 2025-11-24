# 🏥 Medical Symptom Prediction System

This project implements an **End-to-End Natural Language Processing (NLP)** pipeline to predict medical symptoms based on textual descriptions. It was developed as a final project for the **Master's in AI and Data Science** program.

---

## 📄 Project Overview

The goal is to classify unstructured text (patient statements) into one of **25 specific medical symptom categories** (e.g., *Knee pain*, *Heart hurts*, *Anxiety*). The system processes raw text, converts it into semantic vector representations, and uses machine learning classifiers to predict the correct diagnosis.

---

## 🛠️ Methodology

The solution is implemented in a Jupyter Notebook (`Final_project_pln.ipynb`) following these stages:

### 1. Exploratory Data Analysis (EDA) 📊
* Analysis of class distribution to identify potential imbalances.
* Visualization of frequent terms using **WordClouds** and **Frequency Distributions** to understand the symptom vocabulary.

### 2. Advanced Preprocessing (NLP) 🧹
* Implementation of a custom cleaning function using **spaCy** (`en_core_web_lg`).
* **Steps applied:** * Lowercasing.
  * Lemmatization.
  * Stopword removal.
  * Non-alphabetic token filtering.

### 3. Feature Engineering (Embeddings) 🧮
* Usage of **Transfer Learning** with Pre-trained Word Embeddings.
* **Model:** `fasttext-wiki-news-subwords-300` via **Gensim**.
* **Technique:** Document-level vectorization by averaging word embeddings.

### 4. Model Training & Optimization 🤖
* **Split:** 80/20 Train-Test split with stratification.
* **Validation:** 10-Fold Stratified Cross-Validation.
* **Models Evaluated:**
    1.  Logistic Regression
    2.  Support Vector Machine (SVC)
    3.  Random Forest Classifier
* **Optimization:** Hyperparameter tuning using `RandomizedSearchCV`.

---

## 📊 Results

The project achieved exceptional performance, demonstrating the high separability of the dataset based on keywords.

* **🏆 Best Model:** **Random Forest** (closely followed by SVC).
* **🎯 Accuracy on Test Set:** **99.62%**.
* **Key Insight:** The model achieved perfect precision/recall (**1.0**) on 23 out of 25 classes. The only misclassifications occurred between semantically ambiguous classes (*Internal pain* vs. *Stomach ache*), confirming the model's reliance on semantic keywords.

---

## 💻 Tech Stack

* **Language:** Python 3.x
* **NLP Libraries:** `spaCy`, `NLTK`, `Gensim`
* **Machine Learning:** `scikit-learn`
* **Visualization:** `Matplotlib`, `Seaborn`, `WordCloud`

---

## 🚀 How to Run

1.  **Clone this repository:**
    ```bash
    git clone [https://github.com/tu-usuario/tu-repositorio.git](https://github.com/tu-usuario/tu-repositorio.git)
    ```

2.  **Install the required libraries:**
    ```bash
    pip install pandas numpy scikit-learn spacy gensim nltk seaborn matplotlib wordcloud
    python -m spacy download en_core_web_lg
    ```

3.  **Open and run the main notebook:**
    * `Final_project_pln.ipynb`

---
*Author: Pavel Aguilar*