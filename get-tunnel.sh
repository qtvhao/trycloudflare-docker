#!/bin/bash
project_name="$1"
docker_compose_file=$2
NETWORK="$3"
if [ -z "$docker_compose_file" ]; then
    docker_compose_file="docker-compose.yml"
fi
if [ -z "$NETWORK" ]; then
    NETWORK="tryc"
fi
export NETWORK
export CONTAINER_NAME="$project_name-$NETWORK-"$(echo "$project_name-$NETWORK-$ADDRESS" | base64 | tr -d '=' | tr -d '\n' | tr -d '\r' | cut -c1-5)
docker network inspect $NETWORK >/dev/null 2>&1 || docker network create $NETWORK >/dev/null 2>&1
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name-$NETWORK" > /dev/null || sh start-tunnel.sh "$docker_compose_file" "$project_name-$NETWORK" > /dev/null
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name-$NETWORK"
echo
