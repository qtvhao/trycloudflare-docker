set -e -o pipefail
docker_compose_file="$1"
project_name="$2"

if [ -z "$docker_compose_file" ]; then
    docker_compose_file="docker-compose.yml"
fi
if [ -z "$project_name" ]; then
    project_name="tryc"
fi
if [ -z "$CONTAINER_NAME" ]; then
    CONTAINER_NAME="tryc-$project_name"
fi
export CONTAINER_NAME="$CONTAINER_NAME"
echo "docker_compose_file: $docker_compose_file"
echo "project_name: $project_name"
logs=$(docker compose -f $docker_compose_file -p $project_name logs cloudflared-tunnel)
echo "$logs" | grep -oE "Unauthorized" > /dev/null && /bin/sh reset-tunnel.sh "$docker_compose_file" "$project_name"
docker compose -f $docker_compose_file -p $project_name up -d > /dev/null
