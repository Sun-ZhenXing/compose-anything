FROM docker:29-dind

ARG TARGETARCH=amd64
ARG K3S_VERSION=v1.28.2+k3s1

RUN apk add --no-cache bash iptables curl fuse-overlayfs

RUN if [ "$TARGETARCH" = "amd64" ]; then \
    export SUFFIX=""; \
    else \
    export SUFFIX="-$TARGETARCH"; \
    fi &&  \
    curl -L -o /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s${SUFFIX} && \
    chmod +x /usr/local/bin/k3s

EXPOSE 6443

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
