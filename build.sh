docker build -t qtvhao/trycloudflare-docker .
docker push qtvhao/trycloudflare-docker

TUNNEL=$(docker run -e ADDRESS="172.17.0.1:8000" -it --rm \
 -v /var/run/docker.sock:/var/run/docker.sock qtvhao/trycloudflare-docker \
 trycloudflare-docker)

echo "Tunnel: $TUNNEL"
