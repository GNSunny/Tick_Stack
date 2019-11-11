#!/bin/bash -e

docker build -t sunnynehar56/tick .
docker push sunnynehar56/tick


docker volume create --name tick-data  -v /var/lib/influxdb/data -v /var/lib/influxdb/wal -v /var/lib/influxdb/meta 
      -v /data/kapacitor \
      -v /data/chronograf \
      sunnynehar56/tick
      

docker run -d -p 8186:8186 -p 8125:8125/udp -p 10000:10000 \
  --name tick \
  --volumes-from tick-data \
  sunnynehar56/tick
