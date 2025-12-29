ARG DEBIAN_VERSION=13.2-slim
FROM debian:${DEBIAN_VERSION}

# Install dependencies
# ca-certificates, curl, gnupg: for downloading Docker repo key
# iptables: required for Docker networking
# procps: for ps command
# xz-utils, pigz: for compression
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
    && rm -rf /var/lib/apt/lists/*

# Install Docker
# We use the official Docker repository for Debian
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

# Install NVIDIA Container Toolkit (Optional)
ARG INSTALL_NVIDIA_TOOLKIT=false
RUN if [ "$INSTALL_NVIDIA_TOOLKIT" = "true" ]; then \
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
      sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
      tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && apt-get update \
    && apt-get install -y nvidia-container-toolkit \
    && nvidia-ctk runtime configure --runtime=docker \
    && rm -rf /var/lib/apt/lists/*; \
    fi

# Set up dind
# Docker needs a place to store data
VOLUME /var/lib/docker

# Copy entrypoint script
COPY dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Define entrypoint and default command
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["dockerd"]
