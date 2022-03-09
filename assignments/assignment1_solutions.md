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
hdfs dfs -ls /assignment_1/nfl_data
hdfs dfs -tail /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv

#to create screenshots for data blocks 
#inside the container, see the hdfs data directory
cd /root/hdfs/datanode/current
#in the end the data blocks may be at cd /hadoop/hdfs/data/current/BP-1103826538-172.17.0.2-1611940668651/current/finalized/subdir0/subdir0
cd BP-1103826538-172.17.0.2-1611940668651 #different on each container, confirm by ls
cd current/finalized/subdir0/subdir0
ls -lh

#go back to original directory
cd /root/assignment1
```

* First screenshot

  ![image-20220129212157699](images\assignment1_solutions\image-20220129212157699.png)

* Second screenshot

  ![image-20220129212553387](images\assignment1_solutions\image-20220129212553387.png)

* Third screenshot

  ![image-20220129212738821](images\assignment1_solutions\image-20220129212738821.png)

### Task 2.1 Solutions

Commands to run MapReduce job (1 and 4 reducers)

```bash
#with one reducer
pydoop submit --upload-file-to-cache pydoop_mapreduce_nfl_sum.py pydoop_mapreduce_nfl_sum /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_sum_output_0
#how to check results
hdfs dfs -ls /assignment_1/nfl_sum_output_0
hdfs dfs -cat /assignment_1/nfl_sum_output_0/*
hdfs dfs -tail /assignment_1/nfl_sum_output_0/part-r-00000
```

```bash
#with four reducers (the command required)
pydoop submit --num-reducers 4 --upload-file-to-cache pydoop_mapreduce_nfl_sum.py pydoop_mapreduce_nfl_sum /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_sum_output_1
#how to check results
hdfs dfs -ls /assignment_1/nfl_sum_output_1
hdfs dfs -cat /assignment_1/nfl_sum_output_1/*
hdfs dfs -tail /assignment_1/nfl_sum_output_1/part-r-00003
```

* First screenshot

  ![image-20220129213405335](images\assignment1_solutions\image-20220129213405335.png)

* Second screenshot option 1

  ![image-20220129214013934](images\assignment1_solutions\image-20220129214013934.png)

* Second screenshot option 2

  ![image-20220129214200496](images\assignment1_solutions\image-20220129214200496.png)

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

Commands to run MapReduce job (1 and 4 reducers)

```bash
#with one reducer
pydoop submit --upload-file-to-cache pydoop_mapreduce_nfl_avg.py pydoop_mapreduce_nfl_avg /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_avg_output_0
#how to check results
hdfs dfs -ls /assignment_1/nfl_avg_output_0
hdfs dfs -cat /assignment_1/nfl_avg_output_0/*
hdfs dfs -tail /assignment_1/nfl_avg_output_0/part-r-00000
```

```bash
#with four reducers (the command required)
pydoop submit --num-reducers 4 --upload-file-to-cache pydoop_mapreduce_nfl_avg.py pydoop_mapreduce_nfl_avg /assignment_1/nfl_data/NFL_Play_by_Play_2009-2018.csv /assignment_1/nfl_avg_output_1
#how to check results
hdfs dfs -ls /assignment_1/nfl_avg_output_1
hdfs dfs -cat /assignment_1/nfl_avg_output_1/*
hdfs dfs -tail /assignment_1/nfl_avg_output_1/part-r-00003
```

* First screenshot

  ![image-20220129214709805](images\assignment1_solutions\image-20220129214709805.png)

* Second screenshot option 1

  ![image-20220129214818408](images\assignment1_solutions\image-20220129214818408.png)

* Screen screenshot option 2

  ![image-20220129214903009](images\assignment1_solutions\image-20220129214903009.png)

### Task 3 Solutions

Docker and HDFS Commands

```bash
#the two commands required below
#on another terminal window
docker cp {your_path}/assignment1/NFL_Play_by_Play_2009-2018.csv hadoop-master:/root/
#copy file to HDFS
hdfs dfs -copyFromLocal NFL_Play_by_Play_2009-2018.csv /nfl_data

#check file to make sure it is there
hdfs dfs -ls /nfl_data/
```

* Screenshot one on hadoop-worker1

  ![image-20220129215956530](images\assignment1_solutions\image-20220129215956530.png)

* Screenshot two on hadoop-worker2

  ![image-20220129220113078](images\assignment1_solutions\image-20220129220113078.png)



