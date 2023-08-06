# trycloudflare-docker

```shell
TUNNEL=$(docker run -e ADDRESS="172.17.0.1:8000" -it --rm \
 -v /var/run/docker.sock:/var/run/docker.sock qtvhao/trycloudflare-docker \
 bash get-tunnel.sh docker-compose.yml trycloudflare-docker)

echo "Tunnel: $TUNNEL"```
