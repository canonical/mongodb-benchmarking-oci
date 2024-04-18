#!/bin/bash

# preparation steps
ln -sf /usr/bin/python2.7 /usr/bin/python
export PATH="/usr/lib/jvm/java-21-openjdk-amd64/bin/:/usr/share/maven/bin/:$PATH"

# Default values
OPERATIONS_COUNT=1000000
OPERATIONS_THREADS_COUNT=2
MONGODB_URI_DEFAULT="mongodb://localhost:21017/admin?replicaSet=mongodb"
WORKLOAD_DEFAULT="workloada"

# Read parameters or use defaults
WORKLOAD=${1:-$WORKLOAD_DEFAULT}
RECORD_COUNT=${2:-$RECORD_COUNT_DEFAULT}
LOAD_THREADS_COUNT=${3:-$LOAD_THREADS_COUNT_DEFAULT}
MONGODB_URI=${4:-$MONGODB_URI_DEFAULT}



/var/load-testing/ycsb-0.17.0/bin/ycsb \
    run mongodb -s \
    -P "/var/load-testing/ycsb-0.17.0/workloads/$WORKLOAD" \
    -p operationcount=$OPERATIONS_COUNT -threads $OPERATIONS_THREADS_COUNT \
    -p  mongodb.url="$MONGODB_URI"
    