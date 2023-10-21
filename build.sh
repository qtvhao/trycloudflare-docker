docker build -t qtvhao/trycloudflare-docker .
docker push qtvhao/trycloudflare-docker
docker rm -f trycloudflare-docker-cloudflared-tunnel
docker run --name trycloudflare-docker-cloudflared-tunnel -e ADDRESS="172.17.0.1:8000" -d \
 -v /var/run/docker.sock:/var/run/docker.sock qtvhao/trycloudflare-docker \
 trycloudflare-docker
TUNNEL=$(docker logs trycloudflare-docker-cloudflared-tunnel -f)

echo "Tunnel: $TUNNEL"
