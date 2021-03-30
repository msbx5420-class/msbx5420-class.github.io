# Week 12 Exercise - Practice NoSQL Databases

## NoSQL - Redis

```bash
docker pull redis
docker run --name my_redis -d redis
docker exec -it my_redis bash

#get into redis shell
redis-cli
SET mykey value
GET mykey

SET user.5.username andy
SET user.5.session 001
SET user.6.username bella
SET user.6.session 002
SET user.9.username david
SET user.9.session 003

EXISTS user.5
EXISTS user.5.username

KEYS user.*
KEYS user.5.*
GET user.9.session 

DEL user.5.session
DEL user.5.username
KEYS user.5.*
GET user.5.session 

SADD myset "Hello"
SADD myset "World"
SADD myset "!"
SMEMBERS myset
SISMEMBER myset "Hello"
SCARD myset
SREM myset "!"

HSET myhash field_1 "value 1"
HSET myhash field_2 "value 2"
HGETALL myhash
HGET myhash field1

HSET user.3.movies movie_id 3 title "Avengers" genre "Action" year 2012
HGETALL user.3.movies 
HGET user.3.movies title

select 2
exit
```

## NoSQL - MongoDB

More HDFS operations

```bash
docker pull mongo
docker run --name my_mongo -d mongo
docker exec -it my_mongo bash

#get into mongodb shell
mongo
show dbs
use mydb
db
db.mydb.insert({"name":"my_mongodb"})
show dbs

db.createCollection("mycollection_1")
show collections
db.mycollection_2.insert({"name" : "my_mongodb"})
show collections

db.mydb.drop()
show collections

db.mycollection_1.insert({title: 'my_mongo_test', 
    description: 'this is my mongo db test',
    by: 'zhiyiwang',
    url: 'http://www.colorado.edu',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
db.mycollection_1.find().pretty()

db.mycollection_1.update({'title':'my_mongo_test'},{$set:{'title':'My MongoDB Test'}})
db.mycollection_1.find().pretty()

db.mycollection_2.remove({'name':'my_mongodb'})

db.mycollection_1.find({'by':'zhiyiwang', 'title':'My MongoDB Test'}).pretty()
db.mycollection_1.find({$or:[{'by':'zhiyiwang'},{'title': 'My MongoDB Test'}]}).pretty()
db.mycollection_1.find({'likes': {$gt:50}, $or: [{'by': 'zhiyiwang'},{'title': 'My MongoDB Test'}]}).pretty()

exit
```

## Spark with NoSQL (MongoDB)

```bash
docker network create --driver=bridge nosql-net

#change the path to your own
docker run --net=nosql-net -p 8088:8888 -v /mnt/c/Users/zhiyiwang/Dropbox/CU/Teaching/MSBX5420/exercises:/home/jovyan/exercises jupyter/pyspark-notebook

#in another terminal
docker run -d --net=nosql-net --name my_mongo --hostname my-mongodb mongo
docker exec -it my_mongo bash
apt-get update
apt-get install wget
wget https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/inventory.crud.json
mongoimport --db my_test --collection inventory --drop --file inventory.crud.json
```