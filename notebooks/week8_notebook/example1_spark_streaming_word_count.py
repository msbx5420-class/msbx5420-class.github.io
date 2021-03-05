#spark-submit example1_spark_streaming_word_count.py
#nc -lk 9999

import sys
from pyspark import SparkContext, SparkConf
from pyspark.streaming import StreamingContext

sc = SparkContext(conf=SparkConf().setAppName('spark_streaming_word_count').setMaster('local[2]'))
sc.setLogLevel("ERROR")
ssc = StreamingContext(sc, 5)

lines = ssc.socketTextStream('localhost', 9999)

counts = lines.flatMap(lambda line: line.split(" ")) \
              .map(lambda word: (word, 1)) \
              .reduceByKey(lambda a, b: a+b)

counts.pprint()

ssc.start()
ssc.awaitTermination()