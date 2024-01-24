set -xeo pipefail
docker_compose_file="$1"
project_name="$2"
sleep 6

docker rm -f $CONTAINER_NAME
