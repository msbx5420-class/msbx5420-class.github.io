# Assignment 1 Solutions

### Task 1 Solutions

Linux and HDFS Commands to complete the task

```bash
#after getting into the container
./start-hadoop.sh
cd assignment1
ls -lh

#the 5 commands required
#create a directory assignment_1 in hdfs
hdfs dfs -mkdir /assignment_1
hdfs dfs -mkdir /assignment_1/nfl_data
#copy NFL_Play_by_Play_2009-2018.csv to hdfs
hdfs dfs -copyFromLocal NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_data
#list the file
hdfs dfs -ls /assignment_1/nfl_data
#get the last few rows
hdfs dfs -tail /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv

#to create screenshots for data blocks 
#inside each of the datanode container, see the hdfs data directory
cd /root/hdfs/datanode/current
#in the end the data blocks may be at cd /hadoop/hdfs/data/current/BP-1103826538-172.17.0.2-1611940668651/current/finalized/subdir0/subdir0
cd BP-1103826538-172.17.0.2-1611940668651 #different on each container, confirm by ls command
cd current/finalized/subdir0/subdir0
ls -lh
```

* First screenshot


![image-20230127121246720](./images/image-20230127121246720.png)

* Second screenshot

  ![image-20230127121332255](./images/image-20230127121332255.png)

* Screenshot one on hadoop-worker1

  ![image-20230127122119652](./images/image-20230127122119652.png)

* Screenshot two on hadoop-worker2

  ![image-20230127122216058](./images/image-20230127122216058.png)

### Task 2.1 Solutions

Commands to run MapReduce job (4 reducers)

```bash
#with four reducers (the command required)
pydoop submit --num-reducers 4 --upload-file-to-cache pydoop_mapreduce_nfl_sum.py pydoop_mapreduce_nfl_sum /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_sum_output_1
#how to check results
hdfs dfs -ls /assignment_1/nfl_sum_output_1
```

* Screenshot


![image-20230127122450679](./images/image-20230127122450679.png)

### Task 2.2 Solutions

Completed Python Code

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
        avg_yard = total_yards / count
        context.emit(context.key, avg_yard)

def __main__():
    pp.run_task(pp.Factory(Mapper, Reducer))
```

Commands to run MapReduce job (4 reducers)

```bash
#with four reducers (the command required)
pydoop submit --num-reducers 4 --upload-file-to-cache pydoop_mapreduce_nfl_avg.py pydoop_mapreduce_nfl_avg /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_avg_output_1
#how to check results
hdfs dfs -ls /assignment_1/nfl_avg_output_1
```

* Screenshot

  ![image-20230127122624797](./images/image-20230127122624797.png)

### Task 3 Solutions

Load data into Hive tables from HDFS:

```sql
#load the result of sum of plays from HDFS
LOAD DATA INPATH '/assignment_1/nfl_sum_output_1' INTO TABLE nfl.sum_play;
#load the result of average yards from HDFS
LOAD DATA INPATH '/assignment_1/nfl_avg_output_1' INTO TABLE nfl.avg_yard;
```

Hive Query to answer the questions:

```sql
#question 1: 2,526
select count(game_id) from sum_play;
#question 2: 125
select min(sum_plays) from sum_play;
#question 3: 96
select count(game_id) from avg_yard where avg_yards>=5;
```

