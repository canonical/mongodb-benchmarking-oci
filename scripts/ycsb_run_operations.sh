#!/bin/bash

# preparation steps
ln -sf /usr/bin/python2.7 /usr/bin/python
export PATH="/usr/lib/jvm/java-21-openjdk-amd64/bin/:/usr/share/maven/bin/:$PATH"

OPERATIONS_COUNT=1000000
OPERATIONS_THREADS_COUNT=2
MONGODB_URI="mongodb://localhost:21017/admin?replicaSet=mongodb-k8s"
WORKLOAD="workloada"

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--workload) WORKLOAD="$2"; shift ;;
        -oc|--operations-count) OPERATIONS_COUNT="$2"; shift ;;
        -ot|--operations-threads-count) OPERATIONS_THREADS_COUNT="$2"; shift ;;
        -mu|--mongodb-uri) MONGODB_URI="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

/var/load-testing/ycsb-0.17.0/bin/ycsb \
    run mongodb -s \
    -P "/var/load-testing/ycsb-0.17.0/workloads/$WORKLOAD" \
    -p operationcount=$OPERATIONS_COUNT -threads $OPERATIONS_THREADS_COUNT \
    -p  mongodb.url="$MONGODB_URI"
    