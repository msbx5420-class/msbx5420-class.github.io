## Week 1 Exercise Solutions

If you need to copy-paste these commands, please visit https://msbx5420-class.github.io/exercises/ex_week1_solution.html for the same online version, which creates fewer problems when copy-pasting commands.

### Linux Command Practice

```bash
docker pull ubuntu
docker run -it ubuntu
pwd
ls
mkdir msbx5420_ex1
apt-get update
apt-get install vim
cd msbx5420_ex1
touch msbx5420_intro.txt
vi msbx5420_intro.txt
#within vim editor: press i - copy paste content from big_data_intro.txt - press esc - shift + ";" (i.e., type ":") to show ":" - wq
cp msbx5420_intro.txt msbx5420_intro_backup.txt
ls
rm msbx5420_intro.txt
ls
#cd .. - go back to upper level folder (like "Up" in file explorers or finders)
cd ..
```

### Use Jupyter Notebook in Docker

```bash
docker pull jupyter/base-notebook
docker run -p 8888:8888 jupyter/base-notebook
#locate the token in terminal
#visit localhost:8888 and paste the token; use 8889 if 8888 is not working
#now you can't do anything on the original terminal - open a new terminal window
#unzip ex1_week1.zip file so two files are under ex1_week1 folder
#check container id
docker ps
#[IMPORTANT] everytime you see {...}, it is specific to your local computer, so you need to change the whole {...} (including {}) to your own path, folder name, or container id
#[IMPORTANT] paths in Windows typically look like C:\Users\{username}\... paths in MacOS or Linux typically look like /Users/{username}/... you can copy path from file explorer or finder, or drag file into the terminal window to obtain the file path
docker cp {your_local_path}/ex1_week1/word_count_python.ipynb {docker_container_id}:/home/jovyan/word_count_python.ipynb
docker cp {your_local_path}/ex1_week1/big_data_intro.txt {docker_container_id}:/home/jovyan/big_data_intro.txt
#after you run the notebook, you can copy the notebook back to your local file system
docker cp {docker_container_id}:/home/jovyan/word_count_python.ipynb {your_local_path}/word_count_python_results.ipynb
```



```bash
#use docker -v
#you will need to use absolute path when mounting local volume
docker run -p 8888:8888 -v {your_local_path}/ex1_week1:/home/jovyan/ex1_week1 jupyter/base-notebook
#you can check the notebook on local system to see if it has changed after saving it in the container
#you can definitely use another folder name inside container, if you want:
docker run -p 8888:8888 -v {your_local_path}/ex1_week1:/home/jovyan/week1_ex jupyter/base-notebook
#then inside the container you will see week1_ex folder
```

