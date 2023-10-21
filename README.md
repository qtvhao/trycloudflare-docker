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
