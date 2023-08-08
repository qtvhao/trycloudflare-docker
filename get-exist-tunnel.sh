docker_compose_file="$1"
project_name="$2"

set -e
tunnel_container=$(docker compose -f $docker_compose_file -p $project_name ps -q cloudflared-tunnel)
docker inspect -f '{{.State.Running}}' $tunnel_container >/dev/null
if [ $? -eq 0 ]; then
    true
else
    exit 1
fi
matcher=".trycloudflare.com"
while true; do
    logs=$(docker compose -f $docker_compose_file -p $project_name logs cloudflared-tunnel)
    # reverse lines in logs
    logs=$(echo "$logs" | tac)
    echo "$logs" | grep -oP "Unauthorized" > /dev/null && echo "Unauthorized" && exit 1
    echo "$logs" | grep -oP '(?<=https://).*(?=.trycloudflare.com)' | head -n 1 > /dev/null
    if [ $? -eq 0 ]; then
        TRYCLOUDFLARE_DOMAIN="$(echo "$logs" | grep -oP '(?<=https://).*(?=.trycloudflare.com)' | head -n 1)"
        if [ -z "$TRYCLOUDFLARE_DOMAIN" ]; then
            continue;
        fi
        echo "$TRYCLOUDFLARE_DOMAIN""$matcher"
        break;
    else
        echo "Not ready yet..."
        sleep 1
        continue
    fi
done