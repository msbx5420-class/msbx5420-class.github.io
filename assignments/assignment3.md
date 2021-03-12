# MSBX 5420 Assignment 3

In this assignment, you are required to work on three tasks - (1) train topic model (LDA) with Spark ML and refine the model, (2) predict review sentiment with Spark ML, (3) combine spark machine learning and spark streaming to predict review in real time. The tasks are described below, and what you need to do is to complete the missing code in the jupyter notebook *assignment3.ipynb* and submit the notebook.

The dataset we will use in this assignment is IMDB movie reviews dataset (50K reviews). The dataset can be downloaded together with the notebook on Canvas. The data is sample with only two columns, one is the review text, and the other is sentiment label.

You are suggested to use docker to work on the task. If you don't have docker available, or you want to speed up the machine learning training process, you can use MyBinder (class official one [here](https://mybinder.org/v2/gh/msbx5420-class/msbx5420-class.github.io/HEAD)) and EMR cluster (both the small and large clusters are available now). *The code was developed with docker environment - if you use EMR cluster, you will have to adjust the code for reading and saving files, especially for task 3 (i.e., you need to read data and save the small files for streaming with HDFS or S3 directory rather than a local directory), so you can follow the commented code to save and read files with HDFS or S3. Please follow the rules in project instruction to create the directories if you intend to use the second cluster created for project.*

## Task 1 - Topic Modeling with LDA

The first task we are going to train topic model on movie reviews with LDA model. The code in the notebook includes the following steps for task 1:

(1) Clean the text, by removing html tags, special characters and line breaks; then tokenize the text and remove stopwords.

(2) Train a regular LDA model with Spark ML pipeline and display the topics. Here we use word frequency vector to train the model. *You will complete a ML pipeline to train LDA model.*

(3) We improve the model by limiting the minimum word frequency in the vector and train the model with pipeline again. *You will complete a ML pipeline to train LDA model again.*

(4) We then improve the vector by using TF-IDF vector to train with ML pipeline and then compare the topics. *You will create a LDA model to use TF-IDF vector and build a ML pipeline to train LDA.*

### Task 1 Deliverables

Complete the missing code (3 parts) to build ML pipeline and train the models in assignment3.ipynb; display the topics from all the LDA models you have trained in the notebook (code to display topics provided in the notebook).

## Task 2 - Sentiment Analysis with Spark ML

Now in task 2, we continue with the vectors from text and use them to predict sentiment of movie reviews. The code in the notebook includes the following steps for task 2:

(1) Perform sentiment analysis with TF-IDF model and Logistic Regression in ML pipeline; then evaluate the model performance. *You will complete a ML pipeline to train the logistic regression model and then use it to make predictions.*

(2) Predict sentiment with Word2Vec and Logistic Regression in ML pipeline; then evaluate the model performance. *You will create a logistic regression model to use word2vec and build a ML pipeline to train logistic regression model; then make predictions and evaluate model performance.*

(3) Predict sentiment with Word2Vec and Support Vector Machine; then evaluate the model performance. *You will complete a ML pipeline to train SVM model and make predictions.*

### Task 2 Deliverables

Complete the missing code (3 parts) to do sentiment analysis - build ML pipeline, predict sentiment, and evaluate model performance; display the model performance metrics of each sentiment analysis model in the notebook.

## Task 3 - Combine Spark Machine Learning with Spark Streaming

Last, let's apply the machine learning models in a different situation. In week 8, we learned spark streaming to consume live data stream for real-time analysis. Now let's integrate machine learning model into this real-time streaming analysis - read data streams and make predictions on the incoming data.

To do this, we follow we did in week8_structured_streaming_cwl.ipynb to simulate data stream from files in a directory. Then spark will read data stream from the directory for streaming analysis. Therefore, we first turn the test set of movie reviews into a batch of smaller files then they can be read into data stream. The first part of the code does this - it splits the file into 100 small files and save it into a directory for streaming.

Then we read stream from this directory and apply machine learning model on the data stream. Here we just use the latest ML pipeline model we have built - the one with Word2Vec and Support Vector Machine - on the incoming review stream (note that here we should apply the Pipeline Model rather than the Pipeline to make predictions). For each review received from data stream, we add a processing time to the review (we don't have event time for reviews so we just create processing time here). After making predictions, we calculate two results - (1) total number of positive and negative reviews, and (2) total number of positive and negative reviews from every 60 seconds time window in the data stream. Then we create queries for the result tables so we can output the results from the result tables. After the streaming starts, run the SQL queries on the result tables to obtain real-time results (review counts by sentiment/window).

In this process, you will (1) *use the pipeline model with support vector machine to make predictions on review stream* (2) *define the second query to output results*.

### Task 3 Deliverables

Complete the missing code (2 parts) to build this streaming application with machine learning model; after starting the streaming for 3-5 minutes, run the SQL queries to track and display the real-time results in the notebook. Then stop the queries to finish streaming and save your notebook.

## Notes and Rules

### Due Date

Released on Mar 14, due on Mar 21 (for all sections) by end of the day (11:59PM).

### Deliverables

You will submit one jupyter notebook file in Canvas.

You will need to submit the *jupyter notebook assignment3.ipynb with your completed code and output*. Your code should include:

1. Task 1: Complete the code for spark ML pipeline and output the topics from each LDA model
2. Task 2: Complete the code for training and evaluating sentiment analysis models, and output the model performance metrics of prediction
3. Task 3: Complete the code for streaming analysis with machine learning, and output the query results after 3-5 minutes

### Rules

1. work on the assignment independently
2. if you have questions about the assignment, ask as early as possible