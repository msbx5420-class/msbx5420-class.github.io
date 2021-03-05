#spark-submit example2_spark_streaming_stateful_word_count.py
#nc -lk 9999

import sys
from pyspark import SparkContext, SparkConf
from pyspark.streaming import StreamingContext

def updateFunc(new_values, last_sum):
    return sum(new_values) + (last_sum or 0)

sc = SparkContext(conf=SparkConf().setAppName('spark_streaming_stateful_word_count').setMaster('local[2]'))
sc.setLogLevel("ERROR")
ssc = StreamingContext(sc, 5)

ssc.checkpoint("checkpoint")

lines = ssc.socketTextStream('localhost', 9999)

counts = lines.flatMap(lambda line: line.split(" ")) \
              .map(lambda word: (word, 1)) \
              .updateStateByKey(updateFunc)

counts.pprint()

ssc.start()
ssc.awaitTermination()