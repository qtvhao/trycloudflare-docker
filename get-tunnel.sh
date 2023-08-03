docker_compose_file="$1"
project_name="$2"
# docker compose -f $docker_compose_file -p $project_name logs
sh get-tunnel-admin-domain.sh "$docker_compose_file" "$project_name"
