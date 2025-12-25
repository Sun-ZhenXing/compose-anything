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
exec k3s server \
    --snapshotter=native \
    --disable=traefik \
    --write-kubeconfig-mode=644 \
    --https-listen-port=6443 \
    "$@"
