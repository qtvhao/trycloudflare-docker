docker build -t trycloudflare-docker .
docker rm -f trycloudflare-docker-cloudflared-tunnel
docker run --name trycloudflare-docker-cloudflared-tunnel -e ADDRESS="172.17.0.1:8000" -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    trycloudflare-docker \
    some-name
TUNNEL=$(docker logs trycloudflare-docker-cloudflared-tunnel -f)

echo "Tunnel: $TUNNEL"
