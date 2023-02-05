# MSBX 5420 Assignment 1

Please read this instruction carefully to avoid potential issues! If you need to copy-paste some of the commands, please visit https://msbx5420-class.github.io/assignments/assignment1.html for the same online version to do that.

In this assignment, you are required to work on three tasks - (1) use HDFS command lines to copy and manage files, (2) run MapReduce Python code for calculating statistics in NFL data, (3) use Hive to load the results and query the results. We will do that through the hadoop cluster created in the class exercise. Below we will go through the overall process step by step, and the specific tasks you need to do are embedded in the descriptions. Please read the descriptions carefully to make sure you can perform the tasks smoothly.

## Preparation - Create a Hadoop Cluster



## Task 1 - HDFS Commands and Storage Mechanism

The first task is to use HDFS commands. This time we will use a larger dataset to better understand Hadoop Distributed File System (HDFS). 

First, let's get our dataset to use. We will use a dataset for National Football League (NFL). The dataset contains play-by-play information for each NFL match from 2009 to 2018. The original dataset is from Kaggle. For this assignment, I have made some changes to the original dataset so you can download the cleaned dataset here https://www.dropbox.com/s/bi0ftamq4y7hf3q/NFL_Play_by_Play_2009-2018.csv?dl=0. You can then put all files including codes and dataset into a folder to share or mount the folder with docker container later.

Now we are ready to start the first task. First of all, let's follow what we did in the exercise - start the hadoop docker container and create a docker-based hadoop cluster. You can use the commands below or follow the steps in class exercise.

```bash
#only need to do the command below once - if you have done it in the class exercise, skip the command below
docker network create --driver=bridge hadoop
#start a mysql container
docker run -itd --net=hadoop --restart=always --name hadoop-mysql --hostname hadoop-mysql -e MYSQL_ROOT_PASSWORD=admin mysql
#start hadoop master container
docker run -itd --net=hadoop -p 8088:8088 -p 50070:50070 -v {your_path}/assignment1:/root/assignment1 --name hadoop-master --hostname hadoop-master woozlfy/hadoop
#start hadoop slave container
docker run -itd --net=hadoop --name hadoop-worker1 --hostname hadoop-worker1 woozlfy/hadoop
docker run -itd --net=hadoop --name hadoop-worker2 --hostname hadoop-worker2 woozlfy/hadoop
#make sure the containers are running
docker ps
#get into hadoop master container
docker exec -it hadoop-master bash
#after inside the container, start hadoop from the master node
./start-hadoop.sh
```

Now check whether your files are in the directory inside the container. Do ```ls -lh``` to check details of the files. It will show more details about the files.

Now you need to copy the NFL dataset into HDFS. Here you need to do the following steps to complete this task and create the deliverables:

* Create a directory in HDFS as ```/assignment_1/nfl_data``` (<u>Hint:</u> you can create directories twice to do this) (**2 commands**)
* Copy the file ```NFL_Play_by_Play_2009-2018.csv``` to HDFS ```/assignment_1/nfl_data``` (**1 command**)
* List the files in ```/assignment_1/nfl_data``` (**1 command**) and take a screenshot of the output (**1 screenshot**)
* Get the last few rows of ```/assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv``` in HDFS (**1 command**) and take a screenshot of the output (**1 screenshot**)
* Open a new terminal and check the data blocks by getting into each worker node. Once getting into the worker node, ```cd /root/hdfs/datanode/current``` and go to the directory with data blocks (<u>Hint:</u> it is```/root/hdfs/datanode/current/BP-1972853199-172.17.0.2-1611816575402/current/finalized/subdir0/subdir0``` on my machine; it should be different on your machine; adjust the path if different; typically the part ``` BP-431089505-172.17.0.2-1465730089024``` is decided by your machine and you can use `ls` to show it; refer to the exercise for the commands to use). Then find the data blocks, and do ```ls -lh``` to show the details of blocks. Take screenshot of the data blocks on both datanodes (hadoop-worker1, hadoop-worker2) and include them in your report (**2 screenshots**).

### Task 1 Deliverables

In the report, include your commands (**5 commands** in total) and the screenshots (**4 screenshots** in total) of (1) list the directory of ```/assignment_1/nfl_data``` in HDFS after copying the file to HDFS (2) the output of checking last few rows of NFL_Play_by_Play_2009-2018.csv in HDFS and  (3) two screenshots of ```ls -lh``` for the data blocks in each datanode.

## Task 2 - Run MapReduce with Python

Now let's work on some basic statistics with the dataset. Still we are going to calculate some statistics from the NFL dataset we just copied to HDFS. Here we are going to do MapReduce with pydoop. So let's go back to the first terminal window where we just copy the file to HDFS and run HDFS commands.

To run MapReduce with pydoop, we have discussed two ways of running python scripts - one with ```pydoop script``` by short python script that re-writes the map() and reduce() functions, and one with ```pydoop submit``` to have full features MapReduce program. Here we are going to use the second approach with ```pydoop submit``` to make sure the feature implementation. 

First, we will do a summary of number of plays in each NFL game. Because the data is at play level (i.e., the attempt to push forward), we are wondering on how many plays each game has. This is essentially same as ```select game_id, count(*) from NFL_Play_by_Play_2009-2018 group by game_id``` in SQL queries. Now we do this on the dataset with MapReduce. The code below will do this in MapReduce (or see the python code pydoop_mapreduce_nfl_sum.py). 

```python
import pydoop.mapreduce.api as api
import pydoop.mapreduce.pipes as pp

class Mapper(api.Mapper):
    def map(self, context):
        row = context.value.strip().split(",")
        context.emit(row[1], 1)

class Reducer(api.Reducer):
    def reduce(self, context):
        context.emit(context.key, sum(context.values))

def __main__():
    pp.run_task(pp.Factory(Mapper, Reducer))
```

The process is to read each line or row (```pydoop submit``` command will do that automatically) from the dataset in map(). In map(), we get a row of the data, split it, get the game_id, and send (game_id, 1) to reducer. This is because each time a game_id shows up, there is a play; so we are actually doing "game_id count" here, but row by row. The second column in the dataset is game_id, so```row[1]``` is the game_id in the dataset. In reduce(), we are doing the same thing with word count - with each key (game_id), just sum up all the values (ones) together we will get the count of plays for each game_id.

------

### Task 2.1 Submit Python Script for MapReduce

Now you need to run this python script to do MapReduce job with **<u>4 reducers</u>**. Please use the ```pydoop submit``` command with pydoop_mapreduce_nfl_sum.py to run this MapReduce job. Your output directory should be under the ```/assignment1``` directory in HDFS (e.g., `/assignment1/output`). Then use HDFS command to show the list of result files and take a screenshot of the output.

### Task 2.1 Deliverables

In the report, please include your command for submitting python script, and a screenshot of your MapReduce results including the list of result files in HDFS (<u>Hint:</u> to get MapReduce results, you can list the files in your output directory).

------

Next, we want to extend our code to calculate something else. Each play in a football game has statistics about how many yards the play pushes forward (note it could be negative). So let's calculate the average yards gained in each game. Again, it is same as ```select game_id, avg(yards_gained) from NFL_Play_by_Play_2009-2018 group by game_id``` in SQL.

To do this, let's first locate the columns. We know game_id is ```row[1]```, and here the yards_gained is ```row[25]``` (I have identified it for you). So in map(), we can output (game_id, yards_gained) to reducer and the reducer can calculate the average of yards_gained for each game. In reduce(), we can take average for values (a set of yards) under the same key (game_id) and output (game_id, avg_yard) as the results. Here below is the sample code (or see python code pydoop_mapreduce_nfl_avg.py) - it has a completed map(), but with some missing parts in reduce().

```python
import pydoop.mapreduce.api as api
import pydoop.mapreduce.pipes as pp

class Mapper(api.Mapper):
    def map(self, context):
        row = context.value.strip().split(",")
        context.emit(row[1], row[25])

class Reducer(api.Reducer):
    def reduce(self, context):
        yards = context.values
        count = 0
        total_yards = 0
        for yard in yards:
            if yard != "NA":
                count += 1
                total_yards += int(yard)
        #Task 2.2: Complete Your Code Here

def __main__():
    pp.run_task(pp.Factory(Mapper, Reducer))
```

------

### Task 2.2 Complete the Code to Calculate Average Yards

Now you will need to complete the reduce() function and then run your script as a MapReduce job. Same as 2.1, run the MapReduce job with **<u>4 reducers</u>**. Then use HDFS command to list result files and take a screenshot of the output.

### Task 2.2 Deliverables

1. Include your ```pydoop submit``` command to run MapReduce jobs and a screenshot of the results (with the list of result files in HDFS).
2. Complete the python script pydoop_mapreduce_nfl_avg.py as a deliverable.

## Task 3 - Use Hive for Data Management

Now let's use Hive to load the MapReduce results into databases and further analyze that. 

We can get into hive with the command `hive`, and create a database and two tables for the results we get in Task 2 with the code below.

```sql
create database nfl;
use nfl;
CREATE TABLE sum_play (game_id string, sum_plays int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
CREATE TABLE avg_yard (game_id string, avg_yards float)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
```

Now load the MapReduce results for the sum of plays and average yards into the two tables (make sure you are clear where are those final output directories in Task 2), and answer the three questions below with Hive queries:

1. How many distinct games are there in the result?
2. What is the lowest number of plays in all the games?
3. How many distinct games have average yards equal or above 5?

------

Do not forget to stop your containers after finishing the tasks. You can stop/remove them in Docker Desktop.

### Task 3 Deliverables

In the report, please include your queries to load data into tables and answer the questions. Include your answers to the questions in the report as well. 

## Notes and Rules

### Due Date

Feb 12 by end of the day (11:59PM) for all sections.

### Deliverables

You will submit two files in Canvas.

First, you will need to submit <u>an assignment report</u> (word or pdf), which includes:

1. Task 1: Commands to copy file to HDFS and check files (5 in total), and 4 screenshots of listing files and checking data blocks

2. Task 2.1/2.2: Commands for ```pydoop submit``` (1 for each subtask) and 2 screenshots (1 for each subtask) of listing result files
3. Task 3: Queries to load the data into Hive tables and answer the three questions (5 queries in total), and your answers to the three questions

At the same time, submit the completed *pydoop_mapreduce_nfl_avg.py* python script.

### Rules

1. Work on the assignment independently
2. If you have questions about the assignment, ask as early as possible
2. Late submission will receive 1 point deduction (total 10 points) per day
