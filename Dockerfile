FROM debian:bookworm-slim

RUN apt update && apt install -y \
    wget

RUN wget https://get.docker.com -O /tmp/get-docker.sh && \
    sh /tmp/get-docker.sh

RUN apt install -y docker-compose-plugin

WORKDIR /app
COPY reset-tunnel.sh /app/reset-tunnel.sh
COPY get-tunnel.sh /app/get-tunnel.sh
COPY get-exist-tunnel.sh /app/get-exist-tunnel.sh
COPY start-tunnel.sh /app/start-tunnel.sh
COPY docker-compose.yml /app/docker-compose.yml
RUN chmod +x /app/*.sh

ENTRYPOINT [ "/app/get-tunnel.sh" ]
