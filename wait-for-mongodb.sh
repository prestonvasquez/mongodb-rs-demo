#!/bin/bash

NAME=$1
OPTS=$2

while [ -z `mongosh --eval 'db.runCommand("ping").ok' --quiet --host $OPTS 2>/dev/null` ]; do
    echo "Waiting for MongoDB $NAME to start..."
    sleep 1
done

echo "MongoDB $NAME is up and running"

#
#echo "Checking MongoDB 2 status..."
#
#`$CMD mongo2 2>/dev/null` || echo "MongoDB 2 is down!"
#
#echo "Finished checking MongoDB 2 status."

#CMD=<<EOF
#mongosh --tls \
#  --tlsCAFile /data/ssl/ca.pem \
#  --tlsCertificateKeyFile /data/ssl/server.pem \
#  --eval 'db.runCommand("ping").ok' \
#  --quiet --host
#EOF
#
#while [ -z `$CMD mongo1 2>/dev/null` ]
#do
#    echo -n "."
#    sleep 1
#done
#
#echo ""
