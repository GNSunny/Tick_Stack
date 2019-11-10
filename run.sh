#!/bin/bash
CONTAINER_VOLUME=$(docker ps -a | grep tick-data | egrep -o "[a-z0-9]{12}")

  CONTAINER_VOLUME=$(
    docker create \
      --name tick-data \
      -v "/var/lib/influxdb/data" \
      -v "/var/lib/influxdb/wal" \
      -v "/var/lib/influxdb/meta" \
      -v "/data/kapacitor" \
      -v "/data/chronograf" \
      sunnynehar56/tick \
  )

echo ">> Created persisted data container: ${CONTAINER_VOLUME}"

 # docker create --name tick-data -v /var/lib/influxdb/data -v /var/lib/influxdb/wal -v /var/lib/influxdb/meta -v /data/kapacitor -v /data/chronograf  sunnynehar56/tick
docker run \
  -itd \
  -p 8186:8186 \
  -p 8125:8125/udp \
  -p 10000:10000 \
  --name tick \
  --volumes-from $CONTAINER_VOLUME\
  sunnynehar56/tick