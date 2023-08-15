#!/bin/bash
project_name="$1"
docker_compose_file=$2
if [ -z "$docker_compose_file" ]; then
    docker_compose_file="docker-compose.yml"
fi
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name" > /dev/null || sh start-tunnel.sh "$docker_compose_file" "$project_name" > /dev/null
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name"
