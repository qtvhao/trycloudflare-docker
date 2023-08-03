docker_compose_file="$1"
project_name="$2"

logs=$(docker compose -f $docker_compose_file -p $project_name logs cloudflared-tunnel)
echo "$logs" | grep -oP "Unauthorized" > /dev/null && bash reset-tunnel.sh

docker compose -f $docker_compose_file -p $project_name up -d
