#!/usr/bin/env bash

# pull Es image 
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.6.2

# create container network if it doesn't exist
docker network create elastic > /dev/null || true

# start up es cluster or create it first
echo 'Starting up Elastic cluster...'
docker start es || \
docker run \
      --name es \
      --net elastic \
      -p 9200:9200 \
      -e discovery.type=single-node \
      -e ES_JAVA_OPTS="-Xms1g -Xmx1g"\
      -e xpack.security.enabled=false \
      -it docker.elastic.co/elasticsearch/elasticsearch:8.6.2

# follow container logs
docker logs -f $(docker ps | awk NR==2 {print $1})
