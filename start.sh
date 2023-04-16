#!/usr/bin/env bash

echo "-------------------------------------------"
echo "Run cluster origin and destination"
echo "-------------------------------------------"
docker-compose up -d 
echo "-------------------------------------------"

echo "------------------------------------------------"
echo "wait for connect to start..."
echo "------------------------------------------------"

MAX_WAIT=900
CUR_WAIT=0
echo "Waiting up to $MAX_WAIT seconds for connect to start"
docker container logs connect > /tmp/out.txt 2>&1
while [[ ! $(cat /tmp/out.txt) =~ "Kafka Connect started" ]]; do
    sleep 10
    echo "waiting..."
    docker container logs connect > /tmp/out.txt 2>&1
    CUR_WAIT=$(( CUR_WAIT+10 ))
    if [[ "$CUR_WAIT" -gt "$MAX_WAIT" ]]; then
        echo "ERROR: Did not manage to start."
        exit 1
    fi
done
rm /tmp/out.txt
echo "connect has started in $CUR_WAIT seconds!"
echo "-------------------------------------------"

echo "Create topic pageviews on source cluster"
echo "-------------------------------------------"
docker exec broker-1 kafka-topics --create --partitions 2 --topic pageviews --bootstrap-server localhost:9091

echo "------------------------------------------------"
echo "Create pageviews datagen on source cluster"
echo "-------------------------------------------"
curl -i -X POST -H "Content-Type: application/json" --data @./pageviews.json http://localhost:8083/connectors
echo "------------------------------------------------"

echo "------------------------------------------------"
echo "generating some data on pageviews..."
echo "------------------------------------------------"

echo "------------------------------------------------"
echo "Create clusterlink pageviews-link "
echo "-------------------------------------------"
docker exec broker-destination-1 kafka-cluster-links --bootstrap-server broker-destination-1:9391 --create --link pageviews-link --config-file /data/configs/pageviews-link.properties --consumer-group-filters-json-file /data/configs/pageviews-link-consumer-group.json
echo "-------------------------------------------"

echo "------------------------------------------------"
echo "Create mirror topic pageviews"
echo "-------------------------------------------"
docker exec broker-1 kafka-mirrors --create --mirror-topic pageviews --link pageviews-link --bootstrap-server broker-destination-1:9391
echo "-------------------------------------------"

echo "Create topic users on source cluster"
echo "-------------------------------------------"
docker exec broker-1 kafka-topics --create --partitions 2 --topic users --bootstrap-server localhost:9091


echo "------------------------------------------------"
echo "Create users datagen on source cluster"
echo "-------------------------------------------"
curl -i -X POST -H "Content-Type: application/json" --data @./users.json http://localhost:8083/connectors
echo "------------------------------------------------"

echo "------------------------------------------------"
echo "generating some data on users..."
echo "------------------------------------------------"

echo "------------------------------------------------"
echo "Create clusterlink users-link "
echo "-------------------------------------------"
docker exec broker-destination-1 kafka-cluster-links --bootstrap-server broker-destination-1:9391 --create --link users-link --config-file /data/configs/users-link.properties
echo "-------------------------------------------"

echo "------------------------------------------------"
echo "Create mirror topic users"
echo "-------------------------------------------"
docker exec broker-1 kafka-mirrors --create --mirror-topic users --link users-link --bootstrap-server broker-destination-1:9391
echo "-------------------------------------------"

