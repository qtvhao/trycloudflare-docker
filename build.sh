docker build -t qtvhao/trycloudflare-docker .
docker push qtvhao/trycloudflare-docker

TUNNEL=$(docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock qtvhao/trycloudflare-docker \
 bash get-tunnel.sh docker-compose.yml trycloudflare-docker)

echo "Tunnel: $TUNNEL"
