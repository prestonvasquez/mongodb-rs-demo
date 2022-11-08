#!/bin/bash

NAME=$1
OPTS=$2

while [ -z `mongosh --eval 'db.runCommand("ping").ok' --quiet --host $OPTS 2>/dev/null` ]; do
    echo "Waiting for MongoDB $NAME to start..."
    sleep 1
done

echo "MongoDB $NAME is up and running"
