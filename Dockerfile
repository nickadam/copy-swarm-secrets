FROM python:latest AS docker-install

RUN apt-get update && \
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
  curl -fsSL https://download.docker.com/linux/debian/gpg |\
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  apt-get install -y \
    docker-ce-cli

FROM python:latest

COPY --from=docker-install /usr/bin/docker /usr/bin/docker

COPY --from=docker-install /usr/libexec/docker /usr/libexec/docker/

COPY --chmod=644 copy-swarm-secrets.py /
COPY --chmod=755 copy-swarm-secrets.sh /

ENTRYPOINT ["python", "/copy-swarm-secrets.py"]
