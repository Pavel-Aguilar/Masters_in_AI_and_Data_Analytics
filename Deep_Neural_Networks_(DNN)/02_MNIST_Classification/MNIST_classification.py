import matplotlib.pyplot as plt
import numpy as np
from tensorflow.keras.datasets import mnist
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.utils import to_categorical
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report

#%%
# Load data
(X_train, y_train), (X_test, y_test) = mnist.load_data()

#%%
# Visualize some examples
ind = np.random.permutation(len(X_train)) # choose random indices
plt.figure(figsize=(10, 4))
for i in range(10):
    plt.subplot(2, 5, i + 1)
    plt.imshow(X_train[ind[i]], cmap='gray')
    plt.title(f"Label: {y_train[ind[i]]}")
    plt.axis('off')
plt.suptitle("Handwritten digit examples (MNIST)")
plt.tight_layout()
plt.show()

#%%
# Preprocessing
# Add channel dimension at the end and normalize between 0 and 1
X_train = np.expand_dims(X_train, axis=-1) / 255.0 
X_test = np.expand_dims(X_test, axis=-1) / 255.0
y_train_cat = to_categorical(y_train, 10)
y_test_cat = to_categorical(y_test, 10)

#%%
# CNN Model
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)),
    MaxPooling2D((2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D((2, 2)),
    Flatten(),
    Dense(64, activation='relu'),
    Dense(10, activation='softmax')
])

model.summary()
# Compile and train
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
model.fit(X_train, y_train_cat, epochs=5, batch_size=64, validation_split=0.1)

#%%
# Evaluation
test_loss, test_acc = model.evaluate(X_test, y_test_cat)
print(f"Test data accuracy: {test_acc*100:.2f}%")

# Predict some images (first 10)
predictions = model.predict(X_test[:10])
predicted_classes = np.argmax(predictions, axis=1)

# Visualize results
plt.figure(figsize=(10, 4))
for i in range(10):
    plt.subplot(2, 5, i + 1)
    plt.imshow(X_test[i].reshape(28, 28), cmap='gray')
    plt.title(f"Prediction: {predicted_classes[i]}")
    plt.axis('off')
plt.suptitle("CNN Predictions")
plt.tight_layout()
plt.show()


#Confusion matrix and classification report

# Predictions on the ENTIRE test set
y_pred_probs = model.predict(X_test, verbose=0)
y_pred = np.argmax(y_pred_probs, axis=1)
y_true = y_test  # already integer 0-9

# Confusion matrix (counts)
cm = confusion_matrix(y_true, y_pred, labels=np.arange(10))

# visualize absolute counts
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=np.arange(10))
fig, ax = plt.subplots(figsize=(6, 6))
disp.plot(ax=ax, cmap="Blues", values_format="d", colorbar=False)
plt.title("Confusion matrix (absolute counts)")
plt.tight_layout()
plt.show()

# Classification report (precision, recall, f1 per class)
print("\nClassification report:")
print(classification_report(y_true, y_pred, digits=4))