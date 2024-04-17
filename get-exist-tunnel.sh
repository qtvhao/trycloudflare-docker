set -xeo pipefail
docker_compose_file="$1"
project_name="$2"

docker inspect -f '{{.State.Running}}' $CONTAINER_NAME >&2
if [ $? -eq 0 ]; then
    true
else
    docker rm -f $CONTAINER_NAME >&2 || true
    exit 1
fi
matcher=".trycloudflare.com"

logs=$(docker logs $CONTAINER_NAME 2>&1)
logs=$(echo "$logs" | tac)
echo "$logs" | grep -oE "failed to unmarshal quick" && echo "failed to unmarshal quick" && sleep 6 && /bin/sh reset-tunnel.sh "$docker_compose_file" "$project_name" && exit 1
echo "$logs" | grep -oE "Unauthorized" >&2 && echo "Unauthorized" && exit 1
echo $logs | grep -E " https://" | grep -E ".trycloudflare.com" | tr " " "\n" | grep -E "https://" | grep -E ".trycloudflare.com" | head -n 1 >&2 || (sleep 6 && continue)
# if [ $? -eq 0 ]; then
TRYCLOUDFLARE_DOMAIN="$(echo $logs | tr " " "\n" | grep "https" | grep ".trycloudflare.com")" || (sleep 6 && continue)
for line in $TRYCLOUDFLARE_DOMAIN; do
    FOUR_CHARACTERS_FROM_BEGINNING=$(echo "$line" | cut -c1-5)
    if [ "$FOUR_CHARACTERS_FROM_BEGINNING" = "https" ]; then
        line=$(echo "$line" | cut -c9-)
        line=`echo $line | sed 's/[^[:print:]\r\t]//g' | sed 's/\[2K//g'`
        echo "$line"
        mkdir -p /output || true
        echo "$line" > /output/trycloudflare-domain.txt
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
