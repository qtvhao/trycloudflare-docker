FROM debian

RUN apt update && apt install -y \
    wget

RUN wget https://get.docker.com -O /tmp/get-docker.sh && \
    sh /tmp/get-docker.sh

