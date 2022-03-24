

# MSBX 5420 Assignment 4

In this assignment, you are going to work on three tasks - (1) perform graph (network) analysis with spark graphframes on social network data from Facebook, (2) perform graph analysis on community network data from reddit, (3) read data from MySQL database and do a simple analysis. The tasks are described below, and what you need to do is to follow the instructions and complete the missing code in the jupyter notebook *assignment4.ipynb* and submit the notebook.

Collecting network type of data is sometimes not easy, and the most influential data source for network analysis is the data collection from SNAP library (http://snap.stanford.edu/data/). Here we use two datasets from the data collection - one is the Facebook social network (friendship) data, and the other is reddit community network (hyperlink) data. Facebook network data is used for task 1, and reddit community data is used for task 2. For task 3, we will use the example database `employees` from MySQL, as shown in the class exercise in week 10.

You are strongly suggested to use *docker* to work on the tasks as docker would have the least restrictions for this assignment. You may also use MyBinder (class official one [here](https://mybinder.org/v2/gh/msbx5420-class/msbx5420-class.github.io/HEAD)) and EMR cluster but with several limitations (note that MySQL is *NOT* available for MyBinder, and the cluster requires additional setup to work on this assignment). If you need to use the EMR cluster, please let the instructor know to help you with the settings.

## Task 1 - Graph Analysis on Facebook Networks

In the first task, we are going to do graph analysis on the Facebook network. The data is simple but looks pretty boring - to preserve privacy, the data only includes recoded user ids and their friendship (one id is the friend of another id). We will do the following steps in this task:

(1) Load data and build the graph

(2) Calculate degree centrality and pagerank. *You will calculate pagerank for the nodes in the network and show the top importance users.*

(3) Understand shortest paths in the network. *You will calculate the shortest distances from all nodes to node `0` and `25`.*

(4) Identify the clusters in the network. *You will use label propagation to identify clusters, and display the total number and size of clusters.*

### Task 1 Deliverables

Follow the instruction in the notebook to complete the missing code (3 parts) to perform graph analysis in assignment4.ipynb; display top pagerank users, shortest distances distribution (code provided), and total number of clusters as well as size of clusters (*no need to display all, just display the results with `.show()`*).

## Task 2 - Graph Analysis on Reddit Communities

Each graph or network may have its specific features to explore. In the second task, we are going to switch to a different dataset about Reddit communities. Reddit is a popular community for discussing various topics and each topic is under a particular community called subreddit. Sometimes users may refer to the posts in other subreddits when posting in a particular subreddit, so hyperlinks from one subreddit to another subreddit can be found. The data contains such hyperlinks from 2014 to 2017, and we will use this dataset to understand the relations among subreddit communities.

Specifically, we are going to do the following steps in task 2:

(1) Read data, union the two datasets (one for hyperlinks in body, and the other for hyperlinks in title), and build the graph.

(2) Calculate degree centrality and pagerank. *You will calculate pagerank for the nodes in the network and show the top importance communities.*

(3) Identify communities with significant conflicts (negative sentiment in the post with hyperlinks) by querying the edges. *You will calculate the average sentiment based on the instruction in the notebook and display pairs of communities with top negative sentiment.*

(4) Assume you are a random walker in reddit, find the shortest paths from *`leagueoflegends`* community (*League of Legends* is a Multiplayer Online Battle Arena (MOBA) e-sports video game) to *`politics`* community. *You will identify the shortest paths between the two communities following the instruction in the notebook through both **breath-first search** and **motif finding**.*

### Task 2 Deliverables

Follow the instruction in the notebook to complete the missing code (4 parts) to perform graph analysis in assignment4.ipynb; display top pagerank communities, communities with significant conflicts, and shortest paths from *`leagueoflegends`* to *`politics`* by *breath-first search* and *motif finding* (*no need to display all paths, just display the results with `.show()`*).

## Task 3 - Read Data from MySQL

In the third task, we are going to read data from MySQL database. We will continue the class exercise in week 10 where you should have MySQL installed in your *pyspark-notebook* docker container, import the `employees` database, and read tables in spark. We will still use the `employees` database in this task.

As the last task in all assignments, you won't see any existing code here, but what you need to do is simple. As mentioned in the class, in a social network, those nodes that connect multiple groups may be structural holes to have comparative advantages. In a similar vein, although we don't know the social network in this employee database, we may speculate that those employees who have stayed at more than one department may be able to bridge different groups to have the advantages. Therefore, we are going to read the data from `dept_emp` table that stores employee-department relations, and identify those employees who are still at the company by the time of data collection (`to_date` is `9999-01-01`) and have more than one department records in the table. Then display the result by `.show()`. That's all you need to do in this task and you can use any approach in spark to do that.

### Task 3 Deliverables

Follow the instruction in the notebook to complete the missing code (1 part) to read data from MySQL and perform a simple analysis in assignment4.ipynb; display the final dataframe you obtain with employees who are still at the company and have been more than one departments (*no need to display all, just display the results with `.show()`*).

## Notes and Rules

### Due Date

Due on Apr 3 (for all sections).

### Deliverables

You will submit one jupyter notebook file *assignment4.ipynb* in Canvas. Specifically:

1. Task 1: Complete the code for graph analysis with Facebook network and output the required information (pagerank, shortest path distribution, and cluster number/size). You have 3 missing codes to complete.
2. Task 2: Complete the code for graph analysis with Reddit communities, and output the required information (pagerank, communities with conflicts, and shortest paths by two approaches). You have 4 missing codes to complete.
3. Task 3: Write your code to read data from MySQL database and do a simple analysis (output the final filtered dataframe). You have 1 missing codes to complete.

### Rules

1. work on the assignment independently
2. if you have questions about the assignment, ask as early as possible
2. Late submission receives 1 point deduction per day