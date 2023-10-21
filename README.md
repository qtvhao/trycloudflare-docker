# trycloudflare-docker

```shell
docker rm -f some-trycloudflare-docker
docker run -e ADDRESS="172.17.0.1:3000" -it \
    --name some-trycloudflare-docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ghcr.io/qtvhao/trycloudflare-docker:main some-trycloudflare-docker
TUNNEL=$(docker logs some-trycloudflare-docker -f)
echo
echo "Tunnel: $TUNNEL"
```

```yaml
version: '3'
services:
  expose:
    image: ghcr.io/qtvhao/trycloudflare-docker:main
    command: some-tunnel-1 ""
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      ADDRESS: 'http://some_address:${SOME_PORT}'
```

## Run with network

```yaml
version: '3'
services:
  nginx:
    image: nginx
    networks:
      - some-network
  expose:
    image: ghcr.io/qtvhao/trycloudflare-docker:main
    command: some-tunnel-1 "" "some-network"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      ADDRESS: 'http://nginx/'
networks:
  some-network:
    external:
      name: some-network

```
