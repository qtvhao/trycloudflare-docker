#!/bin/bash
set -xeo pipefail
args=("$@")
echo "args: ${args[@]}" >&2
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
echo "Network: $NETWORK" >&2
export NETWORK
export CONTAINER_NAME="$project_name-$NETWORK-"$(echo "$project_name-$NETWORK-$ADDRESS" | md5sum | tr -d '=' | tr -d '\n' | tr -d '\r' | cut -c1-5)
docker network inspect $NETWORK >&2 || docker network create $NETWORK >&2
while true; do
    sh start-tunnel.sh "$docker_compose_file" "$NETWORK" 2>&2
    sh get-exist-tunnel.sh "$docker_compose_file" "$NETWORK" 2>&2 && break || true
    sleep 6
done
