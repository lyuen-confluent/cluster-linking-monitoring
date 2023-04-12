#!/usr/bin/env bash

echo "-------------------------------------------"
echo "Run cluster origin and destination"
echo "-------------------------------------------"
docker-compose up -d 
echo "-------------------------------------------"

echo "------------------------------------------------"
echo "wait for connect to start..."
echo "------------------------------------------------"

sleep 100

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

