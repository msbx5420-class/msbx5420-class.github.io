# Week 12 Exercise - Practice NoSQL Databases

## Redis

First start with the redis container

```bash
docker pull redis
docker run --name my_redis -d redis
docker exec -it my_redis sh

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
```

## MongoDB

More HDFS operations

```bash
docker pull mongo
docker run --name my_mongo -d mongo
docker exec -it my_mongo sh

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
```

## Activity 3

Start to run python code



## Spark with NoSQL

```
docker network create --driver=bridge nosql-net
docker run -itd --net=nosql-net -p 50070:50070 -p 8088:8088 --name hadoop-master --hostname hadoop-master kiwenlau/hadoop:1.0

docker network create --driver=bridge hadoop
#start hadoop master container
docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 --name hadoop-master --hostname hadoop-master kiwenlau/hadoop:1.0
#start hadoop slave container
docker run -itd --net=hadoop --name hadoop-slave1 --hostname hadoop-slave1 kiwenlau/hadoop:1.0
docker run -itd --net=hadoop --name hadoop-slave2 --hostname hadoop-slave2 kiwenlau/hadoop:1.0
```