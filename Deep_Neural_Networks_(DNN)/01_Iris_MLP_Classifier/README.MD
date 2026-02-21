Iris MLP Classifier

This repository contains a complete script for training a Multilayer Perceptron to classify the Iris dataset. The code demonstrates a fundamental deep learning workflow covering data preprocessing and performance visualization.

Installation
You will need Python and a few standard libraries to run this code. Execute the command below in your terminal.
pip install tensorflow numpy matplotlib scikit-learn


Technical Description

Data Preprocessing
The script loads the data and standardizes the numeric features using a standard scaler to ensure mean zero and unit variance. The three target classes are transformed into one hot encoded vectors to prepare them for the network output layer.

Model Architecture
The neural network is built with a sequential approach. It features an input layer tailored for the four floral measurements followed by two dense hidden layers activated by the ReLU function. The final output layer uses the softmax function to predict the probability distribution across the three flower species.

Training Phase
The model compilation uses the Adam optimizer combined with categorical crossentropy loss. The training runs for fifty epochs with a batch size of eight to ensure steady gradient updates.

Expected Results
The evaluation phase calculates the overall accuracy on the separated test data. It also generates a visual confusion matrix using a blue color map to provide a clear view of the exact classification performance for each individual species. Due to the low complexity and limited size of the Iris dataset, the model achieves perfect accuracy on the test data. This optimal score reflects the fundamental simplicity of the classification task rather than exceptional model generalization. In a more complex real world scenario, observing perfect metrics would strongly suggest overfitting and require the implementation of strict regularization techniques.