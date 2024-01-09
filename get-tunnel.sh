#!/bin/bash
set -e -o pipefail
project_name="$1"
docker_compose_file=$2
NETWORK="$3"
if [ -z "$project_name" ]; then
    project_name="default"
fi
if [ -z "$docker_compose_file" ]; then
    docker_compose_file="docker-compose.yml"
fi
if [ -z "$NETWORK" ]; then
    NETWORK="tryc"
fi
export NETWORK
export CONTAINER_NAME="$project_name-$NETWORK-"$(echo "$project_name-$NETWORK-$ADDRESS" | md5sum | tr -d '=' | tr -d '\n' | tr -d '\r' | cut -c1-5)
docker network inspect $NETWORK >/tmp/tunnel.log || docker network create $NETWORK >/tmp/tunnel.log
while true; do
    sh start-tunnel.sh "$docker_compose_file" "$project_name-$NETWORK" 2>/tmp/tunnel.log
    sh get-exist-tunnel.sh "$docker_compose_file" "$project_name-$NETWORK" 2>/tmp/tunnel.log && break || true
    sleep 6
done
