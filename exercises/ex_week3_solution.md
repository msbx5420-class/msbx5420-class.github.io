# Week 3 Exercise - Practice Hadoop, MapReduce and Hive

Same as earlier exercise with command lines, you can visit https://msbx5420-class.github.io/exercises/ex_week3_solution.html for an online version to copy-paste or have a better view.

## Activity 1

First pull the hadoop docker image and start a cluster from it

```bash
#only need to do the command below onece
docker network create --driver=bridge hadoop
#start a mysql container
docker run -itd --net=hadoop --restart=always --name hadoop-mysql --hostname hadoop-mysql -e MYSQL_ROOT_PASSWORD=admin mysql
#start hadoop master container
docker run -itd --net=hadoop -p 8088:8088 -p 50070:50070 -v {your_path}/week3_ex:/root/week3_ex --name hadoop-master --hostname hadoop-master woozlfy/hadoop
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

Let's tart with something simple.

**Note:** in terminal window, you can use Tab (press Tab) to auto fill the file or folder names; for example, if you want to `cd test_folder`, you can type ```cd te``` then press Tab, and the system will try to help to find the files or folders starting with "te"; when there is only one matched result, the system will automatically fill the exact file or folder name. Then you don't need to type the full file or folder name. Try this to simplify the process.

```bash
#get the root directory of HDFS
#HDFS or file system starts with root directory /
hdfs dfs -ls /
#create a directory in HDFS
hdfs dfs -mkdir /test
#check it
hdfs dfs -ls /
```

Now work with Shakespeare.txt

```bash
#check the files first
#here we are inside the container and root is the current user
cd week3_ex
ls
#create a directory week4_ex in hdfs
hdfs dfs -mkdir /week3_ex
#copy Shakespeare.txt to hdfs
hdfs dfs -copyFromLocal Shakespeare.txt /week3_ex
hdfs dfs -ls /week3_ex
hdfs dfs -cat /week3_ex/Shakespeare.txt
hdfs dfs -tail /week3_ex/Shakespeare.txt
```

```bash
#open another terminal window
#on the first datanode
docker exec -it hadoop-worker1 bash
#see the hdfs data directory
cd /root/hdfs/datanode/current
#you will need to go further, for example, mine is at:
#/root/hdfs/datanode/current/BP-1972853199-172.17.0.2-1611816575402/current/finalized/subdir0/subdir0
#yours may be different, so you need to adjust if different, use ls to check
cd BP-1972853199-172.17.0.2-1611816575402
cd current/finalized/subdir0/subdir0
#use ls -lh to check block details
ls -lh
exit

#on the other datanode
docker exec -it hadoop-worker2 bash
#see the hdfs data directory
cd /root/hdfs/datanode/current
#you will need to go further, for example, mine is at:
#/root/hdfs/datanode/current/BP-1972853199-172.17.0.2-1611816575402/current/finalized/subdir0/subdir0
#yours may be different, so you need to adjust if different, use ls to check
cd BP-1972853199-172.17.0.2-1611816575402
cd current/finalized/subdir0/subdir0
#use ls -lh to check block details
ls -lh
exit
```

## Activity 2

More HDFS operations

```bash
#go back to the first terminal window with hadoop master container

#copy files
hdfs dfs -mkdir /week3_ex_backup
hdfs dfs -put Shakespeare.txt /week3_ex_backup
hdfs dfs -cp /week3_ex/Shakespeare.txt /week3_ex_backup/Shakespeare_backup.txt
hdfs dfs -ls /week3_ex_backup

#remove a directory
hdfs dfs -rm -r /week3_ex_backup

#get it back to local file system
hdfs dfs -copyToLocal /week3_ex/Shakespeare.txt Shakespeare_1.txt
hdfs dfs -get /week3_ex/Shakespeare.txt Shakespeare_2.txt
#you should see the two new files Shakespeare_1.txt Shakespeare_2.txt
ls -lh
```

## Activity 3

Start to run python code

```bash
#run the python file for reading data from hdfs
python3 word_count_pydoop.py
```

Then run some mapreduce jobs for word count:

```bash
pydoop script word_count_pydoop_mapreduce_1.py /week3_ex/Shakespeare.txt /week3_ex_output
#structure: pydoop script file_name.py /input /output
#look at the output
hdfs dfs -ls /
hdfs dfs -ls /week3_ex_output
hdfs dfs -cat /week3_ex_output/part-r-00000
hdfs dfs -tail /week3_ex_output/part-r-00000
```

Run the MapReduce job with ```pydoop submit```

```bash
#run a full pydoop program with pydoop submit command
#structure: pydoop submit --upload-file-to-cache file_name.py file_name /input /output
#output directory in HDFS should not exist
pydoop submit --upload-file-to-cache word_count_pydoop_mapreduce_2.py word_count_pydoop_mapreduce_2 /week3_ex/Shakespeare.txt /week3_ex_output_1
#check results
hdfs dfs -ls /week3_ex_output_1
```

Run MapReduce with 4 reducers

```bash
#it allows you to write full mapreduce programs
#now check if more reducers are used
pydoop submit --num-reducers 4 --upload-file-to-cache word_count_pydoop_mapreduce_2.py word_count_pydoop_mapreduce_2 /week3_ex/Shakespeare.txt /week3_ex_output_2
#check results; you should see four files
hdfs dfs -ls /week3_ex_output_2
# * is a wildcard to get all files under the folder, but applicale for -cat
hdfs dfs -cat /week3_ex_output_2/*
hdfs dfs -tail /week3_ex_output_2/part-r-00003
```

## Activity 4

Use Hive to load data and query data

```sql
#get into hive
hive
show databases;
create database shakespeare;
show databases;
use shakespeare;
CREATE TABLE word_count (word string, count int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

LOAD DATA INPATH '/week3_ex_output_2' INTO TABLE shakespeare.word_count;

SELECT * FROM word_count;
SELECT distinct word FROM word_count;
SELECT max(count) FROM word_count;
SELECT * FROM word_count where count>=100;
SELECT * FROM word_count where count>=100 order by count;

#quit; or exit;
exit;
```





## Optional - Hadoop and Docker Management

First confirm the configuration in this hadoop environment:

```bash
cd /opt/hadoop
cd etc/hadoop
cat core-site.xml
cat hdfs-site.xml
#hdfs address is hdfs://hadoop-pseudo:9000
#replicate factor here is 2
#data will be at /root/hdfs/datanode
cd /root/week3_ex
```

Here are some other contents that might be useful for you. 

Stop all containers to make sure your ports are not conflicted

```bash
#stop and remove all containers (regardless of their status)
docker container stop $(docker ps -a -q)
docker container rm $(docker ps -a -q)
```

Some basic YARN commands to check the job status

```bash
#in case something is wrong; application_id can be found at localhost:8088 or by the first command
yarn application -list
yarn application -kill {application_id}

#check the web portal
#8088 - cluster overview
#http://localhost:8088
```

Advanced check

```bash
hadoop fsck / -files -blocks -locations
```

