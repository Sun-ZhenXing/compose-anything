ARG DEBIAN_VERSION=13.2
FROM debian:${DEBIAN_VERSION}

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    iptables \
    procps \
    e2fsprogs \
    xfsprogs \
    xz-utils \
    pigz \
    zstd \
    kmod \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install Kata Containers (Static Binaries)
ARG KATA_VERSION=3.24.0
ARG ARCH=amd64
RUN curl -fsSL https://github.com/kata-containers/kata-containers/releases/download/${KATA_VERSION}/kata-static-${KATA_VERSION}-${ARCH}.tar.zst -o kata-static.tar.zst \
    && tar -I zstd -xvf kata-static.tar.zst -C / \
    && rm kata-static.tar.zst \
    && ln -s /opt/kata/bin/kata-runtime /usr/bin/kata-runtime \
    && ln -s /opt/kata/bin/containerd-shim-kata-v2 /usr/bin/containerd-shim-kata-v2 \
    && ln -s /opt/kata/bin/kata-monitor /usr/bin/kata-monitor \
    && ln -s /opt/kata/bin/kata-collect-data /usr/bin/kata-collect-data \
    && ln -s /opt/kata/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64 || true \
    && ln -s /opt/kata/libexec/virtiofsd /usr/bin/virtiofsd || true

# Configure Kata
RUN mkdir -p /etc/kata-containers \
    && cp /opt/kata/share/defaults/kata-containers/configuration-qemu.toml /etc/kata-containers/ \
    && cp /opt/kata/share/defaults/kata-containers/configuration-fc.toml /etc/kata-containers/ || true

# Install Firecracker
ARG FIRECRACKER_VERSION=1.14.0
RUN if [ "${ARCH}" = "amd64" ]; then ARCH="x86_64"; fi \
    && curl -fsSL https://github.com/firecracker-microvm/firecracker/releases/download/v${FIRECRACKER_VERSION}/firecracker-v${FIRECRACKER_VERSION}-${ARCH}.tgz -o firecracker.tgz \
    && tar -xzf firecracker.tgz \
    && mv release-v${FIRECRACKER_VERSION}-${ARCH}/firecracker-v${FIRECRACKER_VERSION}-${ARCH} /usr/local/bin/firecracker \
    && chmod +x /usr/local/bin/firecracker \
    && rm -rf release-v${FIRECRACKER_VERSION}-${ARCH} firecracker.tgz

# Set up dind
VOLUME /var/lib/docker

# Copy entrypoint script
COPY dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["dockerd"]
