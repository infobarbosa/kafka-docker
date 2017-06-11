# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

#################################################################################

#Variaveis importantes no script
export KAFKA_PROPS=/tmp/server.properties
export KAFKA_HOME=/usr/local/kafka

if [ ! -e "$KAFKA_PROPS" ]; then
  touch "$KAFKA_PROPS"
else
  rm -f "$KAFKA_PROPS"
fi

# The id of the broker. This must be set to a unique integer for each broker.
if [ -z "$BROKER_ID" ]; then
  export BROKER_ID=0
fi

echo "broker.id=$BROKER_ID" >> $KAFKA_PROPS

############################# Socket Server Settings #############################

# The number of threads handling network requests
if [ -z "$NUM_NETWORK_THREADS" ]; then
  export NUM_NETWORK_THREADS=3
fi

echo "num.network.threads=$NUM_NETWORK_THREADS" >> $KAFKA_PROPS

# The number of threads doing disk I/O
if [ -z "$NUM_IO_THREADS" ]; then
  export NUM_IO_THREADS=8
fi

echo "num.io.threads=$NUM_IO_THREADS" >> $KAFKA_PROPS

# The send buffer (SO_SNDBUF) used by the socket server
if [ -z "$SOCKET_SEND_BUFFER_BYTES" ]; then
  export SOCKET_SEND_BUFFER_BYTES="102400"
fi

echo "socket.send.buffer.bytes=$SOCKET_SEND_BUFFER_BYTES" >> $KAFKA_PROPS

# The receive buffer (SO_RCVBUF) used by the socket server
if [ -z "$SOCKET_RECEIVE_BUFFER_BYTES" ]; then
  export SOCKET_RECEIVE_BUFFER_BYTES=102400
fi

echo "socket.receive.buffer.bytes=$SOCKET_RECEIVE_BUFFER_BYTES" >> $KAFKA_PROPS

# The maximum size of a request that the socket server will accept (protection against OOM)
if [ -z "$SOCKET_REQUEST_MAX_BYTES" ]; then
  export SOCKET_REQUEST_MAX_BYTES=104857600
fi

echo "socket.request.max.bytes=$SOCKET_REQUEST_MAX_BYTES" >> $KAFKA_PROPS

############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
if [ -z "$LOG_DIRS" ]; then
  export LOG_DIRS="/tmp/kafka-logs"
fi

echo "log.dirs=$LOG_DIRS" >> $KAFKA_PROPS

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
if [ -z "$NUM_PARTITIONS" ]; then
  export NUM_PARTITIONS=1
fi

echo "num.partitions=$NUM_PARTITIONS" >> $KAFKA_PROPS

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
if [ -z "$NUM_RECOVERY_THREADS_PER_DATA_DIR" ]; then
  export NUM_RECOVERY_THREADS_PER_DATA_DIR=1
fi

echo "num.recovery.threads.per.data.dir=$NUM_RECOVERY_THREADS_PER_DATA_DIR" >> $KAFKA_PROPS

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
if [ -n "$LOG_FLUSH_INTERVAL_MESSAGES" ]; then
  echo "log.flush.interval.messages=$LOG_FLUSH_INTERVAL_MESSAGES" >> $KAFKA_PROPS
fi

# The maximum amount of time a message can sit in a log before we force a flush
if [ -n "$LOG_FLUSH_INTERVAL_MS" ]; then
  echo "log.flush.interval.ms=$LOG_FLUSH_INTERVAL_MS" >> $KAFKA_PROPS
fi

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion
if [ -z "$LOG_RETENTION_HOURS" ]; then
  export LOG_RETENTION_HOURS=168
fi

echo "log.retention.hours=$LOG_RETENTION_HOURS" >> $KAFKA_PROPS

# A size-based retention policy for logs. Segments are pruned from the log as long as the remaining
# segments don't drop below log.retention.bytes.
if [ -n "$LOG_RETENTION_BYTES" ]; then
  echo "log.retention.bytes=$LOG_RETENTION_BYTES" >> $KAFKA_PROPS
fi

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
if [ -z "$LOG_SEGMENT_BYTES" ]; then
  export LOG_SEGMENT_BYTES=1073741824
fi

echo "log.segment.bytes=$LOG_SEGMENT_BYTES" >> $KAFKA_PROPS

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
if [ -z "$LOG_RETENTION_CHECK_INTERVAL_MS" ]; then
  export LOG_RETENTION_CHECK_INTERVAL_MS=300000
fi

echo "log.retention.check.interval.ms=$LOG_RETENTION_CHECK_INTERVAL_MS" >> $KAFKA_PROPS

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
if [ -z "$ZOOKEEPER_CONNECT" ]; then
  export ZOOKEEPER_CONNECT="localhost:2181"
fi

echo "zookeeper.connect=$ZOOKEEPER_CONNECT" >> $KAFKA_PROPS

# Timeout in ms for connecting to zookeeper
if [ -z "$ZOOKEEPER_CONNECTION_TIMEOUT_MS" ]; then
  export ZOOKEEPER_CONNECTION_TIMEOUT_MS=6000
fi

echo "zookeeper.connection.timeout.ms=$ZOOKEEPER_CONNECTION_TIMEOUT_MS" >> $KAFKA_PROPS

#Move o arquivo de propriedades para o diretorio do Kafka
mv $KAFKA_PROPS $KAFKA_HOME/config/

