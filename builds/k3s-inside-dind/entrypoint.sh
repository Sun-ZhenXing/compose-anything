#!/bin/bash
set -e

dockerd-entrypoint.sh &
DOCKER_PID=$!

echo "Waiting for Docker daemon..."
timeout=30
while ! docker info > /dev/null 2>&1; do
    timeout=$(($timeout - 1))
    if [ $timeout -eq 0 ]; then
        echo "Timed out waiting for Docker daemon to start"
        exit 1
    fi
    sleep 1
done
echo "Docker is ready."

echo "Starting K3s..."

# Build K3s server arguments
K3S_ARGS="--snapshotter=native --write-kubeconfig-mode=644 --https-listen-port=6443"

# Add disable services if specified
if [ -n "$K3S_DISABLE_SERVICES" ]; then
    K3S_ARGS="$K3S_ARGS --disable=$K3S_DISABLE_SERVICES"
fi

# Add token if specified
if [ -n "$K3S_TOKEN" ]; then
    export K3S_TOKEN
fi

# Execute K3s server with all arguments
exec k3s server $K3S_ARGS "$@"
