# K3s inside Docker-in-Docker

[中文文档](README.zh.md)

A lightweight Kubernetes distribution (K3s) running inside a Docker-in-Docker (DinD) container. This setup allows you to run a complete Kubernetes cluster within a single Docker container, perfect for development, testing, and CI/CD pipelines.

## Features

- ✅ Complete K3s cluster in a single container
- ✅ Docker-in-Docker support for containerized workloads
- ✅ Kubernetes API server exposed on port 6443
- ✅ Multi-architecture support (x86-64, ARM64)
- ✅ Resource limits to prevent system exhaustion
- ✅ Health checks for cluster readiness
- ✅ Persistent storage for K3s and Docker data
- ✅ Pre-loaded common images for offline use

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 2 CPU cores and 4GB RAM available
- Privileged container support

## Quick Start

1. Copy the environment file:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Customize the configuration in `.env`

3. Build and start the service:

   ```bash
   docker compose up -d --build
   ```

4. Wait for K3s to be ready (check health status):

   ```bash
   docker compose ps
   ```

5. Access the Kubernetes cluster:

   ```bash
   # Copy kubeconfig from container
   docker compose exec k3s cat /etc/rancher/k3s/k3s.yaml > kubeconfig.yaml

   # Use kubectl with the config
   export KUBECONFIG=$(pwd)/kubeconfig.yaml
   kubectl get nodes
   ```

## Configuration

### Environment Variables

| Variable                      | Default        | Description                           |
| ----------------------------- | -------------- | ------------------------------------- |
| `K3S_VERSION`                 | `v1.28.2+k3s1` | K3s version to install                |
| `K3S_DIND_VERSION`            | `0.2.0`        | Built image version tag               |
| `PRELOAD_IMAGES`              | `true`         | Pre-download images during build      |
| `TZ`                          | `UTC`          | Container timezone                    |
| `K3S_API_PORT_OVERRIDE`       | `6443`         | Kubernetes API server port            |
| `DOCKER_TLS_PORT_OVERRIDE`    | `2376`         | Docker daemon TLS port                |
| `K3S_TOKEN`                   | (empty)        | Shared secret for cluster join        |
| `K3S_DISABLE_SERVICES`        | `traefik`      | Services to disable (comma-separated) |
| `K3S_DIND_CPU_LIMIT`          | `2.00`         | CPU limit (cores)                     |
| `K3S_DIND_MEMORY_LIMIT`       | `4G`           | Memory limit                          |
| `K3S_DIND_CPU_RESERVATION`    | `0.50`         | CPU reservation (cores)               |
| `K3S_DIND_MEMORY_RESERVATION` | `1G`           | Memory reservation                    |

### Volumes

- `k3s_data`: K3s cluster data and state
- `docker_data`: Docker daemon data

## Usage Examples

### Deploy a Sample Application

```bash
# Create a deployment
docker compose exec k3s k3s kubectl create deployment nginx --image=nginx

# Expose it as a service
docker compose exec k3s k3s kubectl expose deployment nginx --port=80 --type=NodePort

# Check the service
docker compose exec k3s k3s kubectl get svc nginx
```

### Run Docker Commands Inside K3s

```bash
# Access the container
docker compose exec k3s sh

# Inside the container, you can use both docker and kubectl
docker ps
kubectl get pods -A
```

### Build and Deploy Custom Images

```bash
# Access the container
docker compose exec k3s sh

# Build an image inside the container
docker build -t myapp:latest .

# Deploy to K3s (using the local image)
kubectl create deployment myapp --image=myapp:latest
kubectl set image deployment/myapp myapp=myapp:latest --local -o yaml | kubectl apply -f -
```

## Security Considerations

⚠️ **Important Security Notes:**

- This container runs in **privileged mode**, which grants extensive system access
- Suitable for development and testing environments only
- **DO NOT** use in production without proper security hardening
- The Docker daemon inside is accessible without authentication by default
- All containers share the host's kernel

### Recommended for Production

For production workloads, consider:

- Running K3s natively on hosts or VMs
- Using managed Kubernetes services (EKS, GKE, AKS)
- Implementing proper network isolation
- Enabling RBAC and Pod Security Standards
- Using encrypted communication channels

## Troubleshooting

### Container Fails to Start

Check if your system supports privileged containers:

```bash
docker run --rm --privileged alpine sh -c "echo 'Privileged mode works'"
```

### K3s Server Not Ready

Wait longer for the cluster to initialize (60-90 seconds typically):

```bash
docker compose logs -f k3s
```

### kubectl Connection Refused

Ensure the kubeconfig server address points to `localhost` or the correct IP:

```bash
kubectl cluster-info
```

## Advanced Configuration

### Customize K3s Server Arguments

Modify the `entrypoint.sh` or pass environment variables to customize K3s behavior.

### Enable Additional K3s Services

By default, Traefik is disabled. To enable it:

```bash
# In .env file
K3S_DISABLE_SERVICES=
```

### Change K3s Version

Update the `K3S_VERSION` in `.env` and rebuild:

```bash
docker compose up -d --build
```

### Offline/Air-Gapped Environments

By default, common container images are pre-downloaded during the build process:

- K3s system images (pause, coredns, local-path-provisioner, metrics-server)
- Common base images (nginx, busybox, alpine)

These images are stored in the Docker data volume, so no internet access is required when starting containers.

To disable pre-loading (faster builds if you have good internet):

```bash
# In .env file
PRELOAD_IMAGES=false
```

To add more images to pre-load, edit the Dockerfile and add `docker pull` commands in the pre-load section.

## Cleanup

Remove the cluster and all data:

```bash
docker compose down -v
```

## License

This configuration is provided as-is under the same license as the Compose Anything project.

## References

- [K3s Documentation](https://docs.k3s.io/)
- [Docker-in-Docker](https://hub.docker.com/_/docker)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
