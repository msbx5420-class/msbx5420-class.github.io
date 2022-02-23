# MSBX 5420 Assignment 2

In this assignment, you are required to work on two tasks - (1) a warm-up task that lets you re-work on the two MapReduce calculations in assignment 1, but with spark RDD, dataframe and SQL; (2) solve data analytics problems with spark dataframe or spark SQL. All the existing code and your code will be in the assignment2.ipynb jupyter notebook. Below are the descriptions of each task and hints for solving the problems.

## Task 1 - Warm Up with Spark

Let's first do a warm-up with spark to review the ways of using spark RDD, spark dataframe, and spark SQL. Recall in assignment 1, with MapReduce and NFL dataset, we did two calculations - (1) *number of plays in each football game* (2) *average yards gained per play in each game*. Now let's do them with spark.

First, let's prepare the data. Different from assignment 1, this time with more data ingestion features in spark, we just use the raw data from Kaggle. You can either download the data from Kaggle ([https://www.kaggle.com/maxhorowitz/nflplaybyplay2009to2016](https://www.kaggle.com/maxhorowitz/nflplaybyplay2009to2016)), unzip the file, and simply rename *NFL Play by Play 2009-2018 (v5).csv* to *NFL_Play_by_Play_2009-2018.csv* (no need for more data cleaning), or download from the Dropbox link here ([https://www.dropbox.com/s/upylyr1pxuid8ks/NFL_Play_by_Play_2009-2018.csv?dl=0](https://www.dropbox.com/s/upylyr1pxuid8ks/NFL_Play_by_Play_2009-2018.csv?dl=0)). Although I encourage you to work with larger dataset for this course, if you have troubles in running with this relatively large dataset, please use the following link to download a smaller version: [https://www.dropbox.com/s/90bp47l6k7hlq7m/NFL_Play_by_Play_2009-2018.csv?dl=0](https://www.dropbox.com/s/90bp47l6k7hlq7m/NFL_Play_by_Play_2009-2018.csv?dl=0).

Second, get your environment ready. You are suggested to use docker with `jupyter/pyspark-notebook`, and mount the folder with jupyter notebook and dataset into the container. If you cannot use docker, you can use MyBinder ([mybinder.org](https://mybinder.org)) with your GitHub repo (see week 3 lecture if you need, or use this pre-built one *[here](https://mybinder.org/v2/gh/msbx5420-class/msbx5420-class.github.io/HEAD)*, or let me know and I will help you build one), or use the AWS EMR cluster to run spark (see week 6 and week 7 lectures if you need). Note that if you have to use MyBinder, try to focus on the notebook as it sometimes may be timeout if you don't do anything on it (and make sure to download and save your notebook afterwards - File - Download as - Notebook) After you can visit the files in your jupyter notebook or jupyter lab inside the docker container, open assignment2.ipynb to start the first task.

Now follow the steps in the notebook to complete task 1. In the notebook, we load the data with spark session as a dataframe. Note that here we infer the schema of data with null values as "NA" (recall in the first assignment's python code. we tried to filter "NA"), so `yards_gained` column is integer now (also other columns are in their correct types) so you don't need to transfer the type in calculation. We then drop duplicate rows in the data to make sure our calculation results are correct. Then we convert the `df_nfl` dataframe into an RDD for spark RDD operations, and use the `df_nfl` dataframe for dataframe operations and sql queries. Write your code for the two calculations with spark RDD, spark dataframe, and spark SQL, respectively, and output your results in the notebook by using `take()` or `show()`.

### Task 1 Deliverables

In the jupyter notebook, write the code with spark RDD, spark dataframe, and spark SQL to complete the two calculations (number of plays per game and average yards gained per game).

## Task 2 - Data Analytics with Spark DataFrame and SQL

Now let's work on data analytics with the NFL dataset to generate insights. Data analytics is essentially a problem solving process to understand your data. Now we are wondering some details or statistics in the NFL dataset, and let's use spark dataframe and SQL to obtain these insights.

Below are four questions regarding the details in the NFL data. You will use *spark dataframe or spark SQL* to answer these questions and find the insights. For each question, I discuss their intuitions and hints below. <u>Note that data analytics is to solve problems, and my hints or ways of solving the problems may not be the optimal ones. They are just my own ways of solving these problems, so if you have alternative solutions and they are proven to be better, you will receive bonus mark.</u>

For each of the questions, <u>you can use either spark dataframe API/functions or spark SQL to write your code</u>. Some existing codes I have provided in the notebook use spark dataframe API for conciseness and consistency - you don't need to be constrained by them.

------

### Question 1. Which game(s) has the highest number of plays from 2009 to 2018? And which game has the highest final score difference?

<u>Hint:</u> To solve this problem, you are required to retrieve the game information for the game with the highest number of plays and the highest score difference in the dataset. To do so, look at the notebook: we first build a game level dataset containing the majority of game level information. Because the final scores for each team (home team and away team) are only available after the last play in the game, we keep the record with maximum *play_id* within each *game_id*. We then create another dataframe with game_id and number of plays in each game (as you did in task 1). We then join these two dataframes so we have a full game level dataframe with the number of plays and the scores from both teams. For game(s) with the highest number of plays, you can obtain the game(s) with maximum number of plays from game level dataframe. For game(s) with the highest score difference, you can obtain the score difference as a new column, then obtain the game(s) with maximum score difference.

### Question 2. On average how many plays are needed for a successful touchdown? And how many plays are needed for home team and away team, respectively?

For a football game, touchdown is the most critical way of obtaining scores. A touchdown means a player passing into the end zone holding the ball. It usually takes many plays (attempts) to achieve a touchdown. So in this question, we are wondering the conversion rate from plays into touchdowns (just use rough numbers), and whether the rates are different for home team and away team. Note that in each play, only one of the teams is taking possession of the ball, so some plays are started from the home team, while some are from the away team.

<u>Hint:</u> To solve this problem, you need to perform group count for plays for each game, and group sum for touchdowns (`touchdown` column) for each game. Then calculate the average for number of plays divided by total touchdowns across games. To compare this between home and away teams, you need to do group sum by each game and `posteam_type` (type of team with possession) for total plays and total touchdowns. Then do the same average for number of plays divided by total touchdowns across games, but group by the type of possession team.

### Question 3. For touchdown, which type happened more likely on average, rush touchdown, pass touchdown, or return touchdown? Are the probabilities different by home and away team?

For each touchdown in a football game, it could be pass touchdown (the ball is passed to a player in the end zone to achieve a touchdown), rush touchdown (a player rushing to the end zone to achieve touchdown) or return touchdown (complete a touchdown directly after the punt or kickoff from the opposing team). Now we are wondering which type of touchdown is more likely to happen on average, and whether the probabilities are different by home and away team.

<u>Hint:</u> Similar to question 2, you can first do group sum for total touchdowns, total pass touchdowns, total rush touchdowns, and total return touchdowns for each game. Then take average for the ratio of each type of touchdown across games. For comparison between home and away team, you can do group sum for the touchdown sums by each game and type of team with possession (`posteam_type`) and then average the ratio of each type of touchdown by type of team.

### Question 4. For each calendar year, which team(s) has the highest winning rate?

<u>Hint:</u> To calculate the winning rate, we need three columns for each calendar year from the data - number of winning games, number of games as home team, and number of games as away team. Then we can sum number of games as home and away teams to get total number of games and use winning games divided by total games to get winning rate. To do so, with the game level dataframe we obtained in question 1, we first obtain which team is the winner by comparing the scores from two teams, and get the year of game by substring the game date. Then, we can do three group by with (winner team, game year), (home team, game year) and (away team, game year) so we have three dataframes for each team's number of games as winner team, home team and away team. Next, we join the three dataframes as a new dataframe with all columns together. With the new dataframe, we calculate the total games, and winning rate for each team at each year. Lastly, by each year, we obtain the team(s) with the highest winning rate. Note that the season of NFL is not by calendar year, but for the sake of simplicity and practice, we just apply calendar year here.

### Task 2 Deliverables

Please answer the four questions by completing the missing code and outputting the sample results in the notebook. Make sure you use `show()` or any other dataframe checking approaches to output your results in the notebook. Then submit the completed notebook as your deliverable.

## Notes and Rules

### Due Date

Mar 8 by end of the day (11:59PM) for all sections.

### Deliverables

You will submit one jupyter notebook file in Canvas.

You will need to submit the *jupyter notebook assignment2.ipynb with your completed code and output*. Your code should include:

1. Task 1: Complete the calculations with spark RDD, dataframe and SQL.

2. Task 2: Complete the code for questions 1-4 (for question 1, 2, and 4, complete the missing code; for question 3, write your code)

### Rules

1. Work on the assignment independently
2. If you have questions about the assignment, ask as early as possible
3. Late submission will receive 1 point deduction (total 10 points) per day