FROM docker:29-dind

ARG TARGETARCH=amd64
ARG K3S_VERSION=v1.28.2+k3s1
ARG PRELOAD_IMAGES="true"

RUN apk add --no-cache bash iptables curl fuse-overlayfs jq

RUN if [ "$TARGETARCH" = "amd64" ]; then \
    export SUFFIX=""; \
    else \
    export SUFFIX="-$TARGETARCH"; \
    fi &&  \
    curl -L -o /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s${SUFFIX} && \
    chmod +x /usr/local/bin/k3s

RUN mkdir -p /var/lib/rancher/k3s/agent/images/ && \
    curl -sfL https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s-airgap-images-${TARGETARCH}.tar.zst \
    -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images.tar.zst

EXPOSE 6443

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
