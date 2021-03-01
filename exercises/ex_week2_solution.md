## Exercise 1 Solutions

### Linux Command Practice

```bash
docker pull ubuntu
docker run –it ubuntu
ls
mkdir msbx5420_ex1
apt-get update
apt-get install vim
cd msbx5420_ex1
touch msbx5420_intro.txt
vi msbx5420_intro.txt
#within vim: i - copy paste content - esc - shift + ";" (i.e., type ":") to show ":" - wq
cp msbx5420_intro.txt msbx5420_intro_backup.txt
ls
rm msbx5420_intro.txt
ls
#cd .. - go back to upper level folder (like "Up" in file explorers)
cd ..
```

### Use Jupyter Notebook in Docker

```bash
docker pull jupyter/base-notebook
docker run –p 8888:8888 jupyter/base-notebook
#locate the token in terminal
#visit localhost:8888 and paste the token
#now you can't do anything on the original terminal - open a new terminal window
#put word_count_python.ipynb and bigdata_intro.txt into your terminal working directory
#check container id
docker ps
#use ls to make sure your files are under the currnet working directory; otherwise, copy files to the directory
docker cp word_count_python.ipynb {docker_container_id}:/home/jovyan/word_count_python.ipynb
docker cp big_data_intro.txt {docker_container_id}:/home/jovyan/big_data_intro.txt
#after you run the notebook
docker cp {docker_container_id}:/home/jovyan/word_count_python.ipynb word_count_python_results.ipynb 
```

```bash
#use docker -v
#in your working directory, here assume the user directory (~/)
#note: if you use WSL, the user directory is\\wsl$\Ubuntu\home\username; if you use windows, it is C:\Users\username; if you use mac, it is /Users/username
mkdir ex1_files
cp word_count_python.ipynb ex1_files/
cp big_data_intro.txt ex1_files/
#you will need to use absolute path when mounting local volume
docker run -p 8888:8888 -v ~/ex1_files:/home/jovyan/ex1_files jupyter/base-notebook
#you can check the notebook on local system to see if it has changed after saving it in the container
#you can definitely use another folder name inside container, if you want:
docker run -p 8888:8888 -v ~/ex1_files:/home/jovyan/ex1_myfiles jupyter/base-notebook
#then inside the container you will see ex1_myfiles folder
```

