# MSBX 5420 Assignment 3

In this assignment, you are going to work on three tasks - (1) train topic model (LDA) with Spark ML and refine the model, (2) predict review sentiment with Spark ML, (3) combine spark machine learning and spark streaming to predict review in real time (simulated data stream). The tasks are described below, and what you need to do is to complete the missing code in the jupyter notebook *assignment3.ipynb* and submit the notebook.

The dataset we will use in this assignment is IMDB movie reviews dataset (50K reviews). The dataset can be downloaded together with the notebook on Canvas. The data is simple with only two columns, one is the review text, and the other is sentiment label (positive or negative).

You need to use docker to work on the task. *The code was primarily developed with docker environment.* 

## Task 1 - Topic Modeling with LDA

In the first task we are going to train topic model on movie reviews with LDA model. The code in the notebook includes the following steps for task 1:

(1) Clean the text, by removing html tags, special characters and line breaks; then tokenize the text and remove stop words. 

(2) Train a regular LDA model with Spark ML pipeline and display the topics. Here we use term frequency vector to train the model. *You will build a ML pipeline to train LDA model.*

(3) We try to improve the model by limiting the minimum word frequency in the vector and train the model with ML pipeline again. *You will build a ML pipeline to train LDA model again.*

(4) We then improve the vector by using TF-IDF vector to train with ML pipeline and then compare the topics. *You will create a LDA model to use TF-IDF vector and build a ML pipeline to train LDA.*

### Task 1 Deliverables

Complete the missing code (3 parts) to build ML pipeline and train the models in assignment3.ipynb; display the topics from all the LDA models you have trained in the notebook (code to display topics provided in the notebook).

## Task 2 - Sentiment Analysis with Spark ML

Now in task 2, we continue with the vectors from text and use them to predict sentiment of movie reviews. The code in the notebook includes the following steps for task 2:

(1) Perform sentiment analysis with TF-IDF vector and Logistic Regression in ML pipeline; then evaluate the model performance. *You will build a ML pipeline to train the logistic regression model and then use it to make predictions.*

(2) Predict sentiment with Word2Vec and Logistic Regression in ML pipeline; then evaluate the model performance. *You will create a logistic regression model to use word2vec output and build a ML pipeline to train logistic regression model; then make predictions and evaluate model performance.*

(3) Predict sentiment with Word2Vec and Support Vector Machine; then evaluate the model performance. *You will build a ML pipeline to train SVM model and make predictions.*

### Task 2 Deliverables

Complete the missing code (3 parts) for sentiment analysis - build ML pipeline, predict sentiment, and evaluate model performance; display the model performance metrics of each sentiment analysis model in the notebook.

## Task 3 - Combine Spark Machine Learning with Spark Streaming

Last, let's apply the machine learning model in a different situation. Previously we learned spark streaming to consume live data stream for real-time analysis. Now let's integrate machine learning model into this real-time streaming analysis - read data streams and make predictions on the incoming data.

To do this, we follow what we did in `structured_streaming.ipynb` to simulate data stream from files in a directory (data files sent to directory through `assignment3_streaming_producer.ipynb`). Note Then spark will read data stream from the directory for streaming analysis. We will follow the same way of performing streaming analysis in this task. 

Therefore, we first turn the testing set of movie reviews into a separate csv file. The first part of the code does this. Then you need to go the the `assignment3_streaming_producer.ipynb` to send data to data stream. The notebook will randomly take a few reviews, send them to the streaming directly `./review_stream`, and then randomly wait a couple of seconds before sending next batch of reviews.

Then in the assignment 3 notebook, we read stream from this directory and apply machine learning model on the data stream. Here we just use the latest ML pipeline model we have built - the one with Word2Vec and Support Vector Machine - on the incoming review stream (note that here we should apply the Pipeline Model rather than the Pipeline to make predictions). For each review received from data stream, we add a processing time to the review (we don't have event time for reviews so we just create processing time here). After making predictions, we calculate three results - (1) total number of positive and negative reviews up to now in the data stream, (2) total number of positive and negative reviews from every 60 seconds time window in the data stream, and (3) total number of positive and negative reviews from every 60 seconds sliding every 30 seconds. Then we create queries for the result tables so we can output the results from the result tables. After the streaming starts, run the live dashboard code to query the result tables to obtain real-time results (review counts by sentiment and window).

In this process, you will (1) *use the pipeline model with word2vec and support vector machine to make predictions on review stream* (2) *define the queries of aggregating results and create query variables to output result tables*.

### Task 3 Deliverables

Complete the missing code (3 parts) to build this streaming application with machine learning model; after *completing the missing codes*, run the `assignment3_streaming_producer.ipynb` to start streaming and the live dashboard code to track and display the real-time results in the notebook. Then stop the queries to finish streaming and save your notebook.

## Notes and Rules

### Due Date

Due on Mar 19 (for all sections) by end of the day.

### Deliverables

You will submit one jupyter notebook file in Canvas.

You will need to submit the *jupyter notebook assignment3.ipynb with your completed code and output*. Your code should include:

1. Task 1: Complete the code for spark ML pipeline and output the topics from each LDA model. You have 3 missing codes to complete.
2. Task 2: Complete the code for training and evaluating sentiment analysis models, and output the model performance metrics of prediction. You have 3 missing codes to complete.
3. Task 3: Complete the code for streaming analysis with machine learning, and output the query results through the live dashboard code (2 minutes). You have 3 missing codes to complete.

### Rules

1. work on the assignment independently
2. if you have questions about the assignment, ask as early as possible
2. late submission receives 1 point deduction per day