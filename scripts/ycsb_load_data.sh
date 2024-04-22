#!/bin/bash

# preparation steps
ln -sf /usr/bin/python2.7 /usr/bin/python
export PATH="/usr/lib/jvm/java-21-openjdk-amd64/bin/:/usr/share/maven/bin/:$PATH"

# Default values
RECORD_COUNT=500000
LOAD_THREADS_COUNT=16
MONGODB_URI="mongodb://localhost:21017/admin?replicaSet=mongodb-k8s"
WORKLOAD="workloada"

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--workload) WORKLOAD="$2"; shift ;;
        -rc|--record-count) RECORD_COUNT="$2"; shift ;;
        -lt|--load-threads-count) LOAD_THREADS_COUNT="$2"; shift ;;
        -mu|--mongodb-uri) MONGODB_URI="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Run YCSB with specified parameters
/var/load-testing/ycsb-0.17.0/bin/ycsb \
    load mongodb -s \
    -P "/var/load-testing/ycsb-0.17.0/workloads/$WORKLOAD" \
    -p recordcount=$RECORD_COUNT \
    -threads $LOAD_THREADS_COUNT \
    -p mongodb.url="$MONGODB_URI"