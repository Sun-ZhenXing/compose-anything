# Ray

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个包含 1 个头节点和 2 个工作节点的 Ray 集群，用于分布式计算。

## 服务

- `ray-head`: Ray 头节点，带有仪表板。
- `ray-worker-1`: 第一个 Ray 工作节点。
- `ray-worker-2`: 第二个 Ray 工作节点。

## 环境变量

| 变量名                      | 说明                 | 默认值             |
| --------------------------- | -------------------- | ------------------ |
| RAY_VERSION                 | Ray 镜像版本         | `2.42.1-py312`     |
| RAY_HEAD_NUM_CPUS           | 头节点 CPU 数量      | `4`                |
| RAY_HEAD_MEMORY             | 头节点内存（字节）   | `8589934592` (8GB) |
| RAY_WORKER_NUM_CPUS         | 工作节点 CPU 数量    | `2`                |
| RAY_WORKER_MEMORY           | 工作节点内存（字节） | `4294967296` (4GB) |
| RAY_DASHBOARD_PORT_OVERRIDE | Ray 仪表板端口       | `8265`             |
| RAY_CLIENT_PORT_OVERRIDE    | Ray 客户端服务器端口 | `10001`            |
| RAY_GCS_PORT_OVERRIDE       | Ray GCS 服务器端口   | `6379`             |

请根据实际需求修改 `.env` 文件。

## 卷

- `ray_storage`: Ray 临时文件的共享存储。

## 使用方法

### 启动集群

```bash
docker-compose up -d
```

### 访问 Ray 仪表板

在浏览器中打开:

```text
http://localhost:8265
```

仪表板显示集群状态、正在运行的作业和资源使用情况。

### 从 Python 客户端连接

```python
import ray

# 连接到 Ray 集群
ray.init(address="ray://localhost:10001")

# 运行简单任务
@ray.remote
def hello_world():
    return "Hello from Ray!"

# 执行任务
result = ray.get(hello_world.remote())
print(result)

# 检查集群资源
print(ray.cluster_resources())
```

### 分布式计算示例

```python
import ray
import time

ray.init(address="ray://localhost:10001")

@ray.remote
def compute_task(x):
    time.sleep(1)
    return x * x

# 并行提交 100 个任务
results = ray.get([compute_task.remote(i) for i in range(100)])
print(f"Sum of squares: {sum(results)}")
```

### 使用 Ray Data

```python
import ray

ray.init(address="ray://localhost:10001")

# 创建数据集
ds = ray.data.range(1000)

# 并行处理数据
result = ds.map(lambda x: x * 2).take(10)
print(result)
```

## 功能

- **分布式计算**: 跨多个节点扩展 Python 应用程序
- **自动扩展**: 动态资源分配
- **Ray 仪表板**: 用于监控和调试的 Web UI
- **Ray Data**: 分布式数据处理
- **Ray Train**: ML 模型的分布式训练
- **Ray Serve**: 模型服务和部署
- **Ray Tune**: 超参数调优

## 注意事项

- 工作节点自动连接到头节点
- 集群有 1 个头节点（4 CPU，8GB RAM）和 2 个工作节点（每个 2 CPU，4GB RAM）
- 集群总资源: 8 个 CPU，16GB RAM
- 通过复制工作节点服务定义添加更多工作节点
- 对于 GPU 支持，使用 `rayproject/ray-ml` 镜像并配置 NVIDIA 运行时
- Ray 使用端口 6379 上的 Redis 协议进行集群通信

## 扩展

要添加更多工作节点，添加新的服务定义:

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

## 许可证

Ray 使用 Apache License 2.0 授权。
