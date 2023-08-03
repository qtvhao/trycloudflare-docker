docker_compose_file="$1"
project_name="$2"
docker compose -f $docker_compose_file -p $project_name down
