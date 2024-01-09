set -xeo pipefail
docker_compose_file="$1"
project_name="$2"

tunnel_container=$(docker compose -f $docker_compose_file -p $project_name ps -q cloudflared-tunnel)
docker inspect -f '{{.State.Running}}' $tunnel_container >&2 || true
if [ $? -eq 0 ]; then
    true
else
    docker rm -f $tunnel_container >&2 || true
    exit 1
fi
matcher=".trycloudflare.com"
logs=$(docker compose -f $docker_compose_file -p $project_name logs cloudflared-tunnel) || true
# reverse lines in logs
logs=$(echo "$logs" | tac)
echo "$logs" | grep -oE "failed to unmarshal quick" && docker compose -f $docker_compose_file -p $project_name down cloudflared-tunnel && echo "failed to unmarshal quick" && sleep 6 && exit 1
echo "$logs" | grep -oE "Unauthorized" > /dev/null && echo "Unauthorized" && exit 1
echo $logs | grep -E " https://" | grep -E ".trycloudflare.com" | tr " " "\n" | grep -E "https://" | grep -E ".trycloudflare.com" | head -n 1 >&2 || (sleep 6 && continue)
# if [ $? -eq 0 ]; then
TRYCLOUDFLARE_DOMAIN="$(echo $logs | tr " " "\n" | grep "https" | grep ".trycloudflare.com")" || (sleep 6 && continue)
for line in $TRYCLOUDFLARE_DOMAIN; do
    FOUR_CHARACTERS_FROM_BEGINNING=$(echo "$line" | cut -c1-5)
    if [ "$FOUR_CHARACTERS_FROM_BEGINNING" = "https" ]; then
        line=$(echo "$line" | cut -c9-)
        echo "$line"
        exit 0
    fi
done
echo "$TRYCLOUDFLARE_DOMAIN"
# else
echo "Not ready yet..."
exit 1
#     continue
# fi
# done
