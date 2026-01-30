# MSBX 5420 Group Project

The objective of this group project is to use what we learned in this course to solve some interesting and important problems. I will encourage you to define what is interesting and important from your business perspective. Team members may have different expertise: if you are strong with business - try to contribute from a business perspective; if you are strong in coding - try to contribute to coding. Teams are self-formed with 4-5 members. Anyone without a team will be randomly assigned into teams. Team information will be finalized by the end of March 1.

## Project Requirements

### Basic Requirements

* Dataset: You can use any dataset in the project. However, your data should have substantial size. This is a big data course so datasets below <u>10MB</u> are not allowed. Any dataset is possible, although some recommendations of datasets are provided in case you don't know what data to use. You can also collect your own data if you would like. If you are really interested in a data source but it requires additional data collection effort, please discuss with the instructor for solutions.
* Environment: You can use Docker to develop and test your code. In the end, you are required to use AWS EMR cluster to run your analysis.
* Programming Language: You can use any type of programming languages or business analytics tools, but must include the use of Spark with Python (PySpark), which needs to be deployed on the cluster; that is, if you need to implement a specific feature but it is not available in Spark, you have the flexibility to justify it and use other tools, but meanwhile you still need to make sure you have something implemented by PySpark in that case. Only with PySpark, your implementation shows the potential of horizontal scaling on the AWS EMR cluster.

### Functional Requirements

* Data Ingestion: You can read local files when developing your code locally, but when deploying your code on AWS cluster, you need to save your dataset into Amazon S3. Then read data from Amazon S3 to run your analysis on the AWS cluster. S3 is a convenient data storage place for this project because the data in S3 can be shared across clusters. It is optional, but useful if you save your data as partitioned parquet files in S3 (you can save other type of data as parquet file either through Pandas or PySpark).
* Obtain statistics and perform analysis of the ingested dataset (with PySpark or other packages if necessary) and display your insights (use Jupyter notebook or other type of visualization).

### Performance Requirements

* You can test your application or analysis on your laptop with Docker; you are suggested to make sure your code work on Docker first and then run it on the cluster.
* With your application deployed on the cluster, your implementation should show the potential of horizontal scaling (i.e., when adding more nodes the cluster, the processing should be faster) and take advantage of distributed computing.

### About ChatGPT

* ChatGPT or generative AI tools have been useful for writing reports. In this course, you are allowed to use ChatGPT or AI tools for writing reports if they can generate the content you want. But please clearly state that you use ChatGPT or other AI tools in writing the report.
* Note that the use of ChatGPT or AI tools in writing report will NOT affect any grading of your project report, as long as you indicate which tool you use. However, it may take adverse effect on your grading if your report is very likely written by AI but you don't state the use of AI in the report.

## Project Timeline and Deliverable

> For all project deliverables, they should be submitted on Canvas by one of the team members

* ***<u>Project Proposal (Submit before Consultation):</u>*** You will need to develop a <u>one-page proposal</u> of your project (the second page will not be graded), to <u>discuss the dataset you would like to use</u> and <u>the problems you want to solve from the data</u>. Please be concise on your proposal and motivate your problems - why the problems you want to investigate are <u>important</u> and <u>interesting</u>. Submit your project proposal <u>one day before your consultation time</u>. Note that the proposal is only a summary of your plan and progress, your actual progress doesn't have to be constrained by it. 
* ***<u>Project Consultation (Week 12 March 24/26):</u>*** Your team will make an appointment (30 mins) with instructor by choosing your time slots (which will be confirmed in around Spring break). You will discuss your project with instructor, demonstrate your preliminary works, and get feedback on solving the problems. It is recommended that all team members join the consultation to demonstrate you are working as a whole team. No-show in consultation without reasons will affect participation grade.
* ***<u>Project Presentation (Week 15 April 14/16):</u>*** You will present your problem and analysis (insights) in the class. Your presentation date (April 14 or 16) will be determined by the section of the majority of team members. You are required to do in-person presentation, if possible; only if you have special constraints or you are distance education students, you can do pre-recorded videos for presentation. Submit your presentation slides (and pre-recorded videos, if applicable) on Canvas before your presentation. The order of presentation will be decided by lucky draw. 
  * **Presentation schedule and format requirement**
    * All group members from in-person sections (001/002): in-person presentation only; date depends on the section of the majority of group members; group members who have unresolvable conflicts can record videos which are played by other members who present in-person
    * Most group members from in-person sections with some members from online section: members from online section can record videos and members who present in-person can play the video part from online members
    * Most group members or all group members from online section (800): recorded video presentations submitted on Canvas

* ***<u>Project Implementation (Due April 24):</u>*** You will refine your project after presentation and submit your final application (code, data, etc.) in the project as the deliverable of implementation.
* ***<u>Project Report (Due April 24):</u>*** Based on your problems and insights, you will write a project report to motivate your problem, describe the dataset you use, present your findings and discuss the implications of your findings.

## Project Grading (40% in total)

> Grades on Canvas will be 10 pts, 20 pts, 40 pts and 30 pts for each of the component, respectively. Then the total (100 pts) will be converted as 40% of final grade.

* ***<u>Project Proposal (4%):</u>*** Please be concise on your proposal within one-page. <u>Contents exceeding one-page will not be graded.</u>
* ***<u>Project Presentation (8%):</u>*** Presentation will be 12-15 mins for each group. Make sure your presentation length fall into the range. For either in-person or pre-recorded presentation, make sure all of your team members have engagement in the presentation.
* ***<u>Project Implementation (16%):</u>*** Your implementation (analysis and code) will take 10%, while the deployment of your application (pyspark) on the AWS EMR cluster will take 6%.
* ***<u>Project Report (12%):</u>*** The final report has no page limits (typically 10-15 pages would be sufficient). There is not standard rubric for the report, but your report should discuss your processes or insights rather than displaying your code. For a reference, your final report can include the following components: 
  * Abstract / summary of your report
  * The background and motivation of your questions
  * The dataset and analysis methods
  * The results and insights you have obtained
  * Discuss the implications or stories

## Some Recommendations on Datasets

You can use any dataset you want for this project. In case you have troubles in searching for dataset, some data sources are provided here. 

* COVID-19 related data ([https://www.kaggle.com/datasets?topic=covidDataset](https://www.kaggle.com/datasets?topic=covidDataset))
* AWS opendata ([https://registry.opendata.aws/](https://registry.opendata.aws/))
* Amazon review data ([https://cseweb.ucsd.edu/~jmcauley/datasets.html#amazon_reviews](https://cseweb.ucsd.edu/~jmcauley/datasets.html#amazon_reviews))
* Airbnb data ([http://insideairbnb.com/get-the-data](http://insideairbnb.com/get-the-data))
* Bike share data ([https://www.citibikenyc.com/system-data](https://www.citibikenyc.com/system-data) or [https://www.lyft.com/bikes/bay-wheels/system-data](https://www.lyft.com/bikes/bay-wheels/system-data))
* GitHub data ([https://www.githubarchive.org/](https://www.githubarchive.org/))
* Bitcoin data ([https://www.kaggle.com/bigquery/bitcoin-blockchain](https://www.kaggle.com/bigquery/bitcoin-blockchain))
* Lending data ([https://www.kaggle.com/wordsforthewise/lending-club](https://www.kaggle.com/wordsforthewise/lending-club) or [https://www.kiva.org/build/data-snapshots](https://www.kiva.org/build/data-snapshots))
* Sports data ([https://www.kaggle.com/datasets/hugomathien/soccer](https://www.kaggle.com/datasets/hugomathien/soccer) or [https://www.kaggle.com/datasets/martinellis/nhl-game-data](https://www.kaggle.com/datasets/martinellis/nhl-game-data))
* E-Sports data ([https://www.kaggle.com/devinanzelmo/dota-2-matches](https://www.kaggle.com/devinanzelmo/dota-2-matches) or [http://aligulac.com/about/db/](http://aligulac.com/about/db/))

## Cluster Environment Notes (To Be Updated)

### Connect to AWS EMR Cluster

> The AWS EMR clusters for project are available from March 30 to April 26
>

* Leeds AWS EMR Cluster: Leeds Technology Service has supported for the creation of a series of AWS clusters for the project. 

* Host addresses are:

  * cluster 1: *ec2-52-32-236-168.us-west-2.compute.amazonaws.com*
  * cluster 2: *ec2-34-221-98-70.us-west-2.compute.amazonaws.com*

* Private key file is same with the first cluster - `MSBX5420.pem` 

* For any cluster, create your team directory under absolute path `/mnt1/msbx5420_teams` first and then copy your files to your team directory with `scp`

* All personal directories (if needed) are under `/mnt1/msbx5420` and all team directories are under `/mnt1/msbx5420_teams`

* Please follow the rules to use cluster and create directories. Do not to use the directories under entry directory when you upload large files; it will overload the disk size of master node. If the user directory is full, directories under entry directory will be migrated to `/mnt1/msbx5420_teams`. If you have very large data files and have troubles of uploading them to the cluster, please let the instructor know to help you upload the data.

* Commands to access cluster and copy file from laptop to cluster (make sure your `MSBX5420.pem` inside your current directory with correct permission; `sudo chmod 600 MSBX5420.pem` on Mac if necessary)

  ```bash
  #cluster 1
  ssh -i MSBX5420.pem hadoop@ec2-52-32-236-168.us-west-2.compute.amazonaws.com
  scp -i MSBX5420.pem {your_file} hadoop@ec2-52-32-236-168.us-west-2.compute.amazonaws.com:/mnt1/msbx5420_teams/{team_directory}
  #cluster 2
  ssh -i MSBX5420.pem hadoop@ec2-34-221-98-70.us-west-2.compute.amazonaws.com
  scp -i MSBX5420.pem {your_file} hadoop@ec2-34-221-98-70.us-west-2.compute.amazonaws.com:/mnt1/msbx5420_teams/{team_directory}
  ```

> If the cluster you are using is crowded and hard to get access, you can use the other cluster; but still, make sure your code has been tested locally with Docker first.

* All clusters share the same AWS S3 bucket; if you read data from S3, you don't need to do additional steps

### Use Jupyter Notebook on Cluster

* Create JupyterHub user for your team <u>on the cluster master node (after ssh to the cluster)</u>. *<u>If you use multiple clusters for JupyterHub, please make sure you have the same username across the clusters.</u>* This will make all your users in different clusters share the notebooks.

  ```bash
  sudo docker exec jupyterhub useradd -m -s /bin/bash -N {username}
  sudo docker exec jupyterhub bash -c "echo {username}:{password} | chpasswd"
  ```
  
* Use ssh port forwarding to connect to JupyterHub

  ```bash
  #cluster 1
  ssh -i MSBX5420.pem -N -L localhost:8080:localhost:9443 hadoop@ec2-52-32-236-168.us-west-2.compute.amazonaws.com
  #cluster 2
  ssh -i MSBX5420.pem -N -L localhost:8081:localhost:9443 hadoop@ec2-34-221-98-70.us-west-2.compute.amazonaws.com
  ```
  
* Go to `https://localhost:8080` (cluster 1), or `https://localhost:8081` (cluster 2) in browser and login with your team username and password; then create or upload your notebooks.

* When you see security warning, click "Advanced" or "Details" to continue and bypass it. If you do not find "Advanced" or "Details", blindly type `thisisunsafe` in the page and press `enter` to bypass it.

* To run PySpark program, use the kernel `PySpark` for notebook; you can use sparkmagic with `sc.install_pypi_package()` to make additional packages effective within the notebook. If you need additional python packages on the Python 3 kernel, let the instructor know as early as possible. **Please do not install packages yourself directly on the cluster using pip**.

* In the notebook, you can use sparkmagic to configure your application in terms of resource use; please follow the Wikipedia example to apply it.

* Please avoid uploading data files in JupyterHub. The data files you upload to JupyterHub workspace cannot be loaded by PySpark kernel and running analysis directly from the data file in the workspace will easily overload the master node.

### Use AWS S3 Bucket on Cluster

* For deployment on the cluster, you are recommended to AWS S3; it is a common practice for data storage when using AWS, and it allows your data accessible across clusters

* Our S3 bucket on cluster is `s3://msbx5420-2025`

* Data stored in S3 can be shared across clusters, so when you switch cluster, S3 can be very convenient. That is, S3 doesn't rely on the cluster, so if there is any issue on the cluster, what you save on S3 won't lose.

* To check files and copy files to S3 bucket, you can use the following commands (make sure you have created your team directory on master node and uploaded your files there)

  ```bash
  aws s3 ls s3://msbx5420-2025
  aws s3 ls s3://msbx5420-2025/teams/{team_directory}/
  #copy single file, the last / is required
  aws s3 cp /mnt1/msbx5420_teams/{team_directory}/{file.name} s3://msbx5420-2025/teams/{team_directory}/
  #copy the entire directory
  aws s3 cp /mnt1/msbx5420_teams/{team_directory} s3://msbx5420-2025/teams/{team_directory} --recursive
  ```

* In your Python notebook on JupyterHub, save or read data on S3 bucket with S3 path `s3://msbx5420-2025/teams/{team_directory}/{file.name}`

* Try to clean up your files on the master node after you put them to S3

* If your dataset is super large, please let the instructor know to help your upload the data

