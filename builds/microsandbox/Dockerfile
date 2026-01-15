ARG DEBIAN_VERSION=13.2-slim
FROM debian:${DEBIAN_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG MICROSANDBOX_VERSION
ARG TARGETARCH

RUN apt update && \
    apt install -y --no-install-recommends \
    ca-certificates \
    curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install microsandbox using the official install script
# This ensures we always get the latest version if MICROSANDBOX_VERSION is not set
# and handles architecture detection automatically
RUN VERSION="${MICROSANDBOX_VERSION:-}" \
    curl -fsSL https://raw.githubusercontent.com/zerocore-ai/microsandbox/refs/heads/main/scripts/install_microsandbox.sh | sh

# Setup directories for root user
RUN mkdir -p /root/.local/bin /root/.local/lib /root/.microsandbox

# Set up environment variables
ENV PATH="/root/.local/bin:/usr/local/bin:${PATH}"
ENV LD_LIBRARY_PATH="/root/.local/lib:/usr/local/lib:${LD_LIBRARY_PATH}"
ENV HOME="/root"

# Set working directory to match docker-compose working_dir
WORKDIR /workspace

ARG MICROSANDBOX_AUTO_PULL_IMAGES=true
RUN if [ "${MICROSANDBOX_AUTO_PULL_IMAGES}" = "true" ]; then \
        msb pull microsandbox/python && \
        msb pull microsandbox/node; \
    fi

VOLUME [ "/root/.microsandbox/namespaces" ]

# Default to microsandbox CLI
ENTRYPOINT ["/usr/local/bin/msb"]
CMD ["server", "start", "--host", "0.0.0.0", "--port", "5555"]
