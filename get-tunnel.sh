docker_compose_file="$1"
project_name="$2"
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name" > /dev/null || sh start-tunnel.sh "$docker_compose_file" "$project_name" > /dev/null
sh get-exist-tunnel.sh "$docker_compose_file" "$project_name"
