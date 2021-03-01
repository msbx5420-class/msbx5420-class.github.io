# Exercise 3 Week 4 - Practice Hadoop and MapReduce

## Activity 1

First start with the pydoop container

```bash
docker pull crs4/pydoop
#put the files in folder, mount the folder to /root/your_files folder in the docker container
#here ~ = /Users/username
#I am using ex3_files folder, change the name to your own folder
#Check your folder property to confirm the path of your folder; make sure you are mounting the corrent directory
#Windows - folder -> property; Mac - folder -> Get Info; Or drag the folder into terminal to reveal the path
#if you have troubles in using the ~ in path, just use the absolute path of your system, such as C:/Users/username, or /Users/username
docker run -p 8088:8088 -p 9870:9870 -p 19888:19888 -v ~/ex3_files:/root/ex3_files -d crs4/pydoop
#obtain container_id
docker ps
docker exec -it {container_id} bash
```

Try to copy files into HDFS. The pydoop container has a pseudo distributed hadoop environment.

Start with something simple

**Note:** in Linux, you can use Tab (press Tab) to auto fill the file names; for example, if you want to `cd test_folder`, you can type ```cd te``` then press Tab, and the system will try to help to find the files or folders starting with "te"; when there is only one matched result, the system will automatically fill the exact file or folder name. Then you don't need to type the full file or folder name. Try this to simplify the process.

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
#here we are inside the container and root is the current user: ~ = /root so ~/ex3_files = /root/ex3_files
cd /root/ex3_files
ls
#create a directory wee4_ex in hdfs
hdfs dfs -mkdir /week4_ex
#copy Shakespeare.txt to hdfs
hdfs dfs -copyFromLocal Shakespeare.txt /week4_ex
hdfs dfs -ls /week4_ex
hdfs dfs -cat /week4_ex/Shakespeare.txt
hdfs dfs -tail /week4_ex/Shakespeare.txt

#see the hdfs data directory
cd /hadoop/hdfs/data
#you will need to go further, for example, mine is at:
#/hadoop/hdfs/data/current/BP-1972853199-172.17.0.2-1611816575402/current/finalized/subdir0/subdir0
#yours may be different, so you need to adjust if different
#use ls -lh to check block details

#go back
cd /root/ex3_files
```

## Activity 2

More HDFS operations

```bash
#copy files
hdfs dfs -mkdir /week4_ex_backup
hdfs dfs -put Shakespeare.txt /week4_ex_backup
hdfs dfs -cp /week4_ex/Shakespeare.txt /week4_ex_backup/Shakespeare_backup.txt
hdfs dfs -ls /week4_ex_backup

#remove a directory
hdfs dfs -rm -r /week4_ex_backup

#get it back to local file system
hdfs dfs -copyToLocal /week4_ex/Shakespeare.txt Shakespeare_1.txt
hdfs dfs -get /week4_ex/Shakespeare.txt Shakespeare_2.txt
#you should see the two new files Shakespeare_1.txt Shakespeare_2.txt
ls -lh
```

## Activity 3

Start to run python code

```bash
#run the python file for reading data from hdfs
python word_count_pydoop.py
```

Then run some mapreduce jobs for word count:

```bash
pydoop script word_count_pydoop_mapreduce_1.py /week4_ex/Shakespeare.txt /week4_ex_output
#structure: pydoop script file_name.py /input /output
#look at the output
hdfs dfs -ls /
hdfs dfs -ls /week4_ex_output
hdfs dfs -cat /week4_ex_output/part-r-00000
hdfs dfs -tail /week4_ex_output/part-r-00000
```

Run the MapReduce job with ```pydoop submit```

```bash
#run a full pydoop program with pydoop submit command
#structure: pydoop submit --upload-file-to-cache file_name.py file_name /input /output
pydoop submit --upload-file-to-cache word_count_pydoop_mapreduce_2.py word_count_pydoop_mapreduce_2 /week4_ex/Shakespeare.txt /week4_ex_output_1
#check results
hdfs dfs -ls /week4_ex_output_1
```

Run MapReduce with 4 reducers

```bash
#it allows you to write full mapreduce programs
#now check if more reducers are used
pydoop submit --num-reducers 4 --upload-file-to-cache word_count_pydoop_mapreduce_2.py word_count_pydoop_mapreduce_2 /week4_ex/Shakespeare.txt /week4_ex_output_2
#check results; you should see four folders
hdfs dfs -ls /week4_ex_output_2
# * is a wildcard to get all files under the folder, but applicale for -cat
hdfs dfs -cat /week4_ex_output_2/*
hdfs dfs -tail /week4_ex_output_2/part-r-00003
```



## Optional

First confirm the configuration in this environment (optional):

```bash
cd /opt/hadoop
cd etc/hadoop
cat core-site.xml
cat hdfs-site.xml
#hdfs address is hdfs://{container_id}:9000
#replicate factor here is 1
#data will be at /hadoop/hdfs/data
cd /root/ex3_files
```

Here are some other contents that might be useful for you. 

Stop all containers to make sure your ports are not conflicted

```bash
#stop and remove all containers (regardless of their status)
docker container stop $(docker ps -a -q)
docker container rm $(docker ps -a -q)
```

Some basic YARN commands to check the job status (this can also be on through the web portal)

```bash
#in case something is wrong; application_id can be found at localhost:8088 or the first command
yarn application -list
yarn application -kill {application_id}

#check the web portal
#8088 - cluster overview; 9870 - hdfs overview; 19888 - mapreduce job history
#http://localhost:8088
#http://localhost:9870
#http://localhost:19888
```

Advanced check

```bash
hadoop fsck / -files -blocks -locations
```

