#!/bin/bash -e

docker build -t sunnynehar56/tick .
docker push sunnynehar56/tick


docker volume create  -v /var/lib/influxdb/data -v /var/lib/influxdb/wal -v /var/lib/influxdb/meta 
      -v /data/kapacitor \
      -v /data/chronograf \
      --name tick-data \
      sunnynehar56/tick


docker run -d -p 8186:8186 -p 8125:8125/udp -p 10000:10000 \
  --name tick \
  --volumes-from tick-data \
  sunnynehar56/tick

EXISTS=true
HOST=$(docker-machine env aws-sandbox | grep DOCKER_HOST | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
echo ">> Waiting for Influx to be available on active Docker Host (${HOST})"

if [ $EXISTS != true ]; then
  echo ">> Creating initial telegraf database"
  docker exec -i -t tick curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"
fi

if [[ $? -eq 0 ]]; then
  echo ""
  echo "You are ready to go, head on over to ${HOST}:10000 and start creating metrics!"
fi
