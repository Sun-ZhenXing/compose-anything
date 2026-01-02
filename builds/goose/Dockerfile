FROM debian:bookworm-slim@sha256:b1a741487078b369e78119849663d7f1a5341ef2768798f7b7406c4240f86aef

ARG GOOSE_VERSION=1.18.0
ARG TARGETARCH

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    libdbus-1-3 \
    libxcb1 \
    curl \
    bzip2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install goose binary based on architecture
RUN ARCH=${TARGETARCH:-amd64} && \
    case "${ARCH}" in \
        amd64) GOOSE_ARCH="x86_64" ;; \
        arm64) GOOSE_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: ${ARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/block/goose/releases/download/v${GOOSE_VERSION}/goose-${GOOSE_ARCH}-unknown-linux-gnu.tar.bz2" \
        -o /tmp/goose.tar.bz2 && \
    tar -xjf /tmp/goose.tar.bz2 -C /usr/local/bin && \
    chmod +x /usr/local/bin/goose && \
    rm /tmp/goose.tar.bz2

# Create non-root user
RUN useradd -m -u 1000 -s /bin/bash goose && \
    mkdir -p /home/goose/.config/goose && \
    chown -R goose:goose /home/goose

# Set up environment
ENV PATH="/usr/local/bin:${PATH}"
ENV HOME="/home/goose"

# Switch to non-root user
USER goose
WORKDIR /home/goose

# Default to goose CLI
ENTRYPOINT ["/usr/local/bin/goose"]
CMD ["--help"]
