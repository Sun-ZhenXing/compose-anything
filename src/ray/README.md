# Ray

[English](./README.md) | [中文](./README.zh.md)

This service deploys a Ray cluster with 1 head node and 2 worker nodes for distributed computing.

## Services

- `ray-head`: Ray head node with dashboard.
- `ray-worker-1`: First Ray worker node.
- `ray-worker-2`: Second Ray worker node.

## Environment Variables

| Variable Name               | Description                | Default Value      |
| --------------------------- | -------------------------- | ------------------ |
| RAY_VERSION                 | Ray image version          | `2.42.1-py312`     |
| RAY_HEAD_NUM_CPUS           | Head node CPU count        | `4`                |
| RAY_HEAD_MEMORY             | Head node memory (bytes)   | `8589934592` (8GB) |
| RAY_WORKER_NUM_CPUS         | Worker node CPU count      | `2`                |
| RAY_WORKER_MEMORY           | Worker node memory (bytes) | `4294967296` (4GB) |
| RAY_DASHBOARD_PORT_OVERRIDE | Ray Dashboard port         | `8265`             |
| RAY_CLIENT_PORT_OVERRIDE    | Ray Client Server port     | `10001`            |
| RAY_GCS_PORT_OVERRIDE       | Ray GCS Server port        | `6379`             |

Please modify the `.env` file as needed for your use case.

## Volumes

- `ray_storage`: Shared storage for Ray temporary files.

## Usage

### Start the Cluster

```bash
docker-compose up -d
```

### Access Ray Dashboard

Open your browser and navigate to:

```text
http://localhost:8265
```

The dashboard shows cluster status, running jobs, and resource usage.

### Connect from Python Client

```python
import ray

# Connect to the Ray cluster
ray.init(address="ray://localhost:10001")

# Run a simple task
@ray.remote
def hello_world():
    return "Hello from Ray!"

# Execute the task
result = ray.get(hello_world.remote())
print(result)

# Check cluster resources
print(ray.cluster_resources())
```

### Distributed Computing Example

```python
import ray
import time

ray.init(address="ray://localhost:10001")

@ray.remote
def compute_task(x):
    time.sleep(1)
    return x * x

# Submit 100 tasks in parallel
results = ray.get([compute_task.remote(i) for i in range(100)])
print(f"Sum of squares: {sum(results)}")
```

### Using Ray Data

```python
import ray

ray.init(address="ray://localhost:10001")

# Create a dataset
ds = ray.data.range(1000)

# Process data in parallel
result = ds.map(lambda x: x * 2).take(10)
print(result)
```

## Features

- **Distributed Computing**: Scale Python applications across multiple nodes
- **Auto-scaling**: Dynamic resource allocation
- **Ray Dashboard**: Web UI for monitoring and debugging
- **Ray Data**: Distributed data processing
- **Ray Train**: Distributed training for ML models
- **Ray Serve**: Model serving and deployment
- **Ray Tune**: Hyperparameter tuning

## Notes

- Workers automatically connect to the head node
- The cluster has 1 head node (4 CPU, 8GB RAM) and 2 workers (2 CPU, 4GB RAM each)
- Total cluster resources: 8 CPUs, 16GB RAM
- Add more workers by duplicating the worker service definition
- For GPU support, use `rayproject/ray-ml` image and configure NVIDIA runtime
- Ray uses Redis protocol on port 6379 for cluster communication

## Scaling

To add more worker nodes, add new service definitions:

```yaml
ray-worker-3:
  <<: *defaults
  image: ${GLOBAL_REGISTRY:-}rayproject/ray:${RAY_VERSION:-2.42.1-py312}
  container_name: ray-worker-3
  command: ray start --address=ray-head:6379 --block
  depends_on:
    - ray-head
  environment:
    RAY_NUM_CPUS: ${RAY_WORKER_NUM_CPUS:-2}
    RAY_MEMORY: ${RAY_WORKER_MEMORY:-4294967296}
```

## License

Ray is licensed under the Apache License 2.0.
