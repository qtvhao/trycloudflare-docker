set -xe -o pipefail
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
echo "docker_compose_file: $docker_compose_file" >&2
echo "project_name: $project_name" >&2
logs=$(docker logs $CONTAINER_NAME) || true
echo "$logs" | grep -oE "Unauthorized" >&2 && /bin/sh reset-tunnel.sh "$docker_compose_file" "$project_name"
echo "Starting tunnel..." >&2

docker run -d --name $CONTAINER_NAME --network ${NETWORK:-tryc}_default cloudflare/cloudflared:2023.10.0 tunnel --url ${ADDRESS} >&2 || true
