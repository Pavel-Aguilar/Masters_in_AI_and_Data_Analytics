MNIST CNN Classifier

This repository contains an end to end pipeline for training and evaluating a Convolutional Neural Network designed to classify handwritten digits. The code demonstrates a complete deep learning workflow from data ingestion to advanced performance analysis using the MNIST dataset.

Installation
You will need Python and the following libraries to run the script. 
pip install tensorflow numpy matplotlib scikit-learn


Technical Description
Data Preprocessing
The script loads the image data and adds a single color channel dimension to make the arrays compatible with Keras convolutional layers. Pixel values are normalized to a zero to one range to stabilize gradient convergence. All numerical labels are transformed into one hot encoded vectors.

Model Architecture
The neural network follows a sequential architecture. It utilizes two main feature extraction blocks containing Conv2D and MaxPooling2D layers activated by ReLU. The spatial dimensions are then flattened and passed through a dense hidden layer before reaching the final 10 neuron softmax classification layer.

Training Phase
The compilation uses the Adam optimizer and categorical crossentropy for the loss function. The training runs for 5 epochs with a batch size of 64 while dynamically reserving ten percent of the data for validation.

Expected Results and Metrics
The script goes beyond basic accuracy metrics. It evaluates the model against the unseen test set and generates a visual plot comparing the raw images against the network predictions. To provide deeper performance insights, it generates a complete confusion matrix and a detailed classification report displaying precision, recall, and f1 scores for each individual digit class.