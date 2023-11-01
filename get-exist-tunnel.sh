docker_compose_file="$1"
project_name="$2"

tunnel_container=$(docker compose -f $docker_compose_file -p $project_name ps -q cloudflared-tunnel)
docker inspect -f '{{.State.Running}}' $tunnel_container >/dev/null 2>&1
if [ $? -eq 0 ]; then
    true
else
    docker rm -f $tunnel_container >/dev/null
    exit 1
fi
set -e
matcher=".trycloudflare.com"
while true; do
    logs=$(docker compose -f $docker_compose_file -p $project_name logs cloudflared-tunnel 2>&1)
    # reverse lines in logs
    logs=$(echo "$logs" | tac)
    echo "$logs" | grep -oE "Unauthorized" > /dev/null && echo "Unauthorized" && exit 1
    echo $logs | grep -E "https://" | grep -E ".trycloudflare.com" | tr " " "\n" | grep -E "https://" | grep -E ".trycloudflare.com" | head -n 1 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        TRYCLOUDFLARE_DOMAIN="$(echo $logs | grep -E "https://" | grep -E ".trycloudflare.com" | tr " " "\n" | grep -E "https://" | grep -E ".trycloudflare.com" | head -n 1)"
        if [ -z "$TRYCLOUDFLARE_DOMAIN" ]; then
            continue;
        fi
        echo "$TRYCLOUDFLARE_DOMAIN" | tr -d '[:space:]'
        break;
    else
        echo "Not ready yet..."
        sleep 1
        continue
    fi
done
