# Overview

![image](files:./../img/architecture.png)

## Getting Started

1. Execute the script "runme_once.sh", it will download "jmx-monitoring-stacks" repo to your local directory and copy over the customized config files

```
% ./runme_once.sh 
>>> Download jmx-monitoring-stacks..
Cloning into 'jmx-monitoring-stacks'...
remote: Enumerating objects: 1476, done.
remote: Counting objects: 100% (363/363), done.
remote: Compressing objects: 100% (123/123), done.
remote: Total 1476 (delta 272), reused 285 (delta 234), pack-reused 1113
Receiving objects: 100% (1476/1476), 6.24 MiB | 8.93 MiB/s, done.
Resolving deltas: 100% (717/717), done.
>>> copying files to jmx-monitoring-stacks...
>>> done
```

! This step only have to be run once.

2. Execute the script "start.sh" to spin up the environment.

```
% ./start.sh 
-------------------------------------------
Run cluster origin and destination
-------------------------------------------
[+] Running 13/13
 ⠿ Network cluster-linking-monitoring_default  Created                                                 0.0s
 ⠿ Container grafana                           Started                                                 1.1s
 ⠿ Container prometheus                        Started                                                 1.2s
 ⠿ Container node-exporter                     Started                                                 0.9s
 ⠿ Container zookeeper                         Started                                                 1.0s
 ⠿ Container zookeeper-destination             Started                                                 1.0s
 ⠿ Container broker-destination-1              Started                                                 1.7s
 ⠿ Container broker-destination-2              Started                                                 1.6s
 ⠿ Container broker-2                          Started                                                 1.4s
 ⠿ Container broker-1                          Started                                                 1.5s
 ⠿ Container schema-registry                   Started                                                 2.0s
 ⠿ Container connect                           Started                                                 2.5s
 ⠿ Container control-center                    Started                                                 3.0s
-------------------------------------------
------------------------------------------------
wait for connect to start...
------------------------------------------------
Create topic pageviews on source cluster
-------------------------------------------
Created topic pageviews.
------------------------------------------------
Create pageviews datagen on source cluster
-------------------------------------------
HTTP/1.1 201 Created
Date: Wed, 12 Apr 2023 10:08:19 GMT
Location: http://localhost:8083/connectors/datagen-pageviews
Content-Type: application/json
Content-Length: 345

{"name":"datagen-pageviews","config":{"connector.class":"io.confluent.kafka.connect.datagen.DatagenConnector","kafka.topic":"pageviews","key.converter":"org.apache.kafka.connect.storage.StringConverter","quickstart":"PAGEVIEWS","tasks.max":"1","max.interval":"1000","_iterations":"1000000","name":"datagen-pageviews"},"tasks":[],"type":"source"}------------------------------------------------
------------------------------------------------
generating some data on pageviews...
------------------------------------------------
------------------------------------------------
Create clusterlink pageviews-link 
-------------------------------------------
Cluster link 'pageviews-link' creation successfully completed.
-------------------------------------------
------------------------------------------------
Create mirror topic pageviews
-------------------------------------------
Created topic pageviews.
-------------------------------------------
Create topic users on source cluster
-------------------------------------------
Created topic users.
------------------------------------------------
Create users datagen on source cluster
-------------------------------------------
HTTP/1.1 201 Created
Date: Wed, 12 Apr 2023 10:08:27 GMT
Location: http://localhost:8083/connectors/datagen-users
Content-Type: application/json
Content-Length: 305

{"name":"datagen-users","config":{"connector.class":"io.confluent.kafka.connect.datagen.DatagenConnector","kafka.topic":"users","key.converter":"org.apache.kafka.connect.storage.StringConverter","quickstart":"USERS","tasks.max":"1","max.interval":"2000","name":"datagen-users"},"tasks":[],"type":"source"}------------------------------------------------
------------------------------------------------
generating some data on users...
------------------------------------------------
------------------------------------------------
Create clusterlink users-link 
-------------------------------------------
Cluster link 'users-link' creation successfully completed.
-------------------------------------------
------------------------------------------------
Create mirror topic users
-------------------------------------------
Created topic users.
-------------------------------------------
```
3. Access Control Center from "http://localhost:9021"
4. Access Grafana from "http://localhost:3000" (admin/password)
5. Open the dashboard on Grafana called "Cluster Linking Demo"

