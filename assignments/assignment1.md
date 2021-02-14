# MSBX 5420 Assignment 1

In this assignment, you are required to work on three tasks - (1) use HDFS command lines to copy and manage files, (2) run MapReduce Python code for calculating statistics in NFL data, (3) work with HDFS in a (docker simulated) hadoop cluster. Below we will go through the overall process step by step, and the specific tasks you need to do are embedded in the descriptions. Please read the descriptions carefully to make sure you can perform the tasks smoothly.

## Task 1 - HDFS Commands

The first task is to use HDFS commands. This time we will use a relatively larger dataset to better understand Hadoop Distributed File System (HDFS). 

First, let's get our dataset to use. We will use a dataset for National Football League (NFL). The dataset contains play-by-play information for each NFL match from 2009 to 2018. You can download the original data from Kaggle. You can check the data description and download the data here - https://www.kaggle.com/maxhorowitz/nflplaybyplay2009to2016. You will need a Kaggle account to download the data. Kaggle is a data science platform with rich datasets and scripts. It is a good platform for learning data science techniques so there is no harm to sign up an account if you haven't had one.

After downloading the data, you will need to do some simple cleaning on the dataset first. If you unzip the downloaded archive, you will see three csv files. We will use the NFL Play by Play 2009-2018 (v5).csv data file. For our tasks, we will apply some changes: (1) rename the file to NFL_Play_by_Play_2009-2018.csv (file name with spaces sometimes causes troubles) (2) delete the column "desc" (here the textual content will affect data processing) (3) delete the first row (the header) (pydoop by default is not as smart as other python packages). <u>The file is large so in case you have troubles in applying the changes, you can download the cleaned dataset here</u> https://www.dropbox.com/s/eka2lnhupuz27dv/NFL_Play_by_Play_2009-2018.csv?dl=0: 

Now we are ready to start the first task. First of all, let's follow what we did in the exercise - start the pydoop docker container and get into the pseudo distributed environment.

```bash
docker pull crs4/pydoop
docker run -p 8088:8088 -p 9870:9870 -p 19888:19888 -v ~/your_files:/root/your_files -d crs4/pydoop
docker ps
docker exec -it {container_id} bash
cd ~/your_files
```

Now check whether your files are in the directory inside the container. Do ```ls -lh``` to check details of the files. It will show more details about the files.

Now you need to copy the NFL dataset into HDFS. Here you need to do the following steps to complete this task and create the deliverables:

* Create a directory in HDFS as ```/assignment_1/nfl_data``` (<u>Hint:</u> you can create directories twice to do this) (**2 commands**)
* Copy the file ```NFL_Play_by_Play_2009-2018.csv``` to HDFS ```/assignment_1/nfl_data``` (**1 command**)
* List the files in ```/assignment_1/nfl_data``` (**1 command**)
* Get the last few rows of ```/assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv``` in HDFS (**1 command**)
* Check the data blocks by going to ```cd /hadoop/hdfs/data``` and go to the directory with data blocks (<u>Hint:</u> it is```/hadoop/hdfs/data/current/BP-1972853199-172.17.0.2-1611816575402/current/finalized/subdir0/subdir0``` on my machine; it should be different on your machine; adjust the path if different; typically the part ``` BP-431089505-172.17.0.2-1465730089024``` is decided by your machine; watch the lecture recording for the exact procedure), then find the data blocks, and do ```ls -lh``` to show the blocks
* Go back to ```~/your_files```

### Task 1 Deliverables

In the report, include your commands (**5 commands** in total) and the screenshots (3 in total) of (1) list the directory of ```/assignment_1/nfl_data``` in HDFS after copying the file (2) the result of checking last few rows of NFL_Play_by_Play_2009-2018.csv in HDFS (3) the data blocks in the HDFS data directory shown by ```ls -lh```.



## Task 2 - Run MapReduce with Python

Now let's work on some basic statistics with the dataset. Still we are going to calculate some statistics from the NFL dataset we just copied to HDFS. Here we are going to do MapReduce with pydoop. So let's continue with the pydoop docker container.

To run MapReduce with pydoop. we have discussed two ways of running python scripts - one with ```pydoop script``` by short python script that re-writes the map() and reduce() functions, and one with ```pydoop submit``` to have full features MapReduce program. Here we are going to use the second approach with ```pydoop submit``` to make sure the feature implementation. 

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

Now you need to submit this python script to do MapReduce job with **4 reducers**. Please use the ```pydoop submit``` command with pydoop_mapreduce_nfl_sum.py to run this MapReduce job. Your output directory should be under the ```/assignment1``` directory in HDFS.

### Task 2.1 Deliverables

In the report, please include your command for submitting python script, and two screenshots of your MapReduce results including the list of result files in HDFS and the result content in the files (<u>Hint:</u> to get MapReduce results, you can list the files in your output directory and get the content via -cat or -tail on the results).

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

Now you will need to complete the reduce() function and then submit your script as a MapReduce job. Same as 2.1, run the MapReduce job with **4 reducers**. (<u>Hint:</u> when dividing values, if both variables are integer, the result will be integer. To avoid that, apply float() on the variables first.)

### Task 2.2 Deliverables

1. Include your ```pydoop submit``` command to run MapReduce jobs and the results (with the list of result files in HDFS and sample results in the files).
2. Complete the python script pydoop_mapreduce_nfl_avg.py as a deliverable.

------

Do not forget to stop your container after finishing the tasks.



## Task 3 - HDFS with Hadoop Cluster

Last, what we have done is based on a pseudo distributed environment with single namenode/datanote on one machine. Next let's try to work with a cluster to see what's happening with a hadoop cluster. The commands below will let you start a hadoop cluster on your local machine. So first make sure you can start the docker container based cluster with the following commands. The cluster contains one namenode and two datanodes.

```bash
docker pull kiwenlau/hadoop:1.0
docker network create --driver=bridge hadoop
#start hadoop master container
docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 --name hadoop-master --hostname hadoop-master kiwenlau/hadoop:1.0
#start hadoop slave container
docker run -itd --net=hadoop --name hadoop-slave1 --hostname hadoop-slave1 kiwenlau/hadoop:1.0
docker run -itd --net=hadoop --name hadoop-slave2 --hostname hadoop-slave2 kiwenlau/hadoop:1.0
#make sure the containers are running
docker ps
#get into hadoop master container
docker exec -it hadoop-master bash
#start hadoop from the master node
./start-hadoop.sh
#make sure the hdfs cluster works
hdfs dfs -mkdir /nfl_data
hdfs dfs -ls /
```

Now, let's save files to HDFS in this hadoop cluster. First copy the file NFL_Play_by_Play_2009-2018.csv to the master node in the docker cluster. Then inside the container, copy the file to HDFS. The task steps are:

* Copy your file (NFL_Play_by_Play_2009-2018.csv) from local file system to hadoop-master container (<u>Hint:</u> target location is ```hadoop-master:/root/```) (**1 command**)
* Copy the file NFL_Play_by_Play_2009-2018.csv to HDFS at ```/nfl_data``` (**1 command**)

Then let's check the data blocks:

```bash
#on the first datanode
docker exec -it hadoop-slave1 bash
cd hdfs/datanode/current/BP-431089505-172.17.0.2-1465730089024/current/finalized/subdir0/subdir0
#it can be at the directory above - it should be different on your machine; if different adjust yourself
ls -lh

#on the other datanode
docker exec -it hadoop-slave2 bash
cd hdfs/datanode/current/BP-431089505-172.17.0.2-1465730089024/current/finalized/subdir0/subdir0
#same, if different you need to adjust the path
ls -lh
```

* Here you should be able to see the replications. Take screenshot of the data blocks on both datanodes (hadoop-slave1, hadoop-slave2) and include them in your report.
* You can stop and/or remove all containers after finishing the task

### Task 3 Deliverables

In the report, please include your commands to copy file to hadoop-master container and HDFS (**2 commands** in total), and two screenshots of ```ls -lh``` for the data blocks in each datanode.



## Notes and Rules

### Due Date

One week after the announcement - Feb 9 (Section 003) / Feb 11 (Section 002/003B) by end of the day (11:59PM).

### Deliverables

You will submit two files in Canvas.

First, you will need to submit <u>an assignment report</u> (word or pdf), which includes:

1. Task 1: Commands to copy file to HDFS and check files (5 in total), and 3 screenshots of listing files and checking data

2. Task 2.1/2.2: Command for ```pydoop submit``` and 2 screenshots of result files and result contents
3. Task 3: Commands for copying file to container and HDFS (2 in total), and 2 screenshots of data blocks on each datanode

At the same time, submit the <u>completed pydoop_mapreduce_nfl_avg.py python script</u>.

### Rules

1. work on the assignment independently
2. if you have questions about the assignment, ask as early as possible