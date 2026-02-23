# GPUStack

[English](./README.md) | [中文](./README.zh.md)

GPUStack 是一个开源的 GPU 集群管理器，用于运行和扩展大型语言模型（LLM）。

## 快速开始

```bash
docker compose up -d
```

在 <http://localhost:80> 访问 Web UI，默认凭据为 `admin` / `admin`。

## 服务

- `gpustack`：默认启用 GPU 支持的 GPUStack 服务器

## 端口

| 服务     | 端口 |
| -------- | ---- |
| gpustack | 80   |

## 环境变量

| 变量名                      | 描述                      | 默认值    |
| --------------------------- | ------------------------- | --------- |
| GPUSTACK_VERSION            | GPUStack 镜像版本         | `v0.7.1`  |
| TZ                          | 时区设置                  | `UTC`     |
| GPUSTACK_HOST               | 服务器绑定的主机地址      | `0.0.0.0` |
| GPUSTACK_PORT               | 服务器绑定的端口          | `80`      |
| GPUSTACK_DEBUG              | 启用调试模式              | `false`   |
| GPUSTACK_BOOTSTRAP_PASSWORD | 引导管理员用户的密码      | `admin`   |
| GPUSTACK_TOKEN              | Worker 注册令牌           | （自动）  |
| HF_TOKEN                    | Hugging Face 模型下载令牌 | （空）    |
| GPUSTACK_PORT_OVERRIDE      | 主机端口映射              | `80`      |

## 卷

- `gpustack_data`：GPUStack 数据目录

## GPU 支持

本服务默认配置了 NVIDIA GPU 支持。配置使用：

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          device_ids: ['0']
          capabilities: [gpu]
```

### 要求

- 支持 CUDA 的 NVIDIA GPU
- 主机上安装了 NVIDIA Container Toolkit
- Docker 19.03+ 支持 GPU

### AMD GPU（ROCm）

要使用支持 ROCm 的 AMD GPU：

1. 在 `docker-compose.yaml` 中使用 ROCm 特定镜像：

   ```yaml
   image: ${GLOBAL_REGISTRY:-}gpustack/gpustack:${GPUSTACK_VERSION:-v0.7.1}-rocm
   ```

2. 将设备驱动更改为 `amdgpu`：

   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: amdgpu
             device_ids: ['0']
             capabilities: [gpu]
   ```

## 使用方法

### 部署模型

1. 在 <http://localhost:80> 登录 Web UI
2. 导航到 **Models** → **Deploy Model**
3. 从目录中选择模型或添加自定义模型
4. 配置模型参数
5. 点击 **Deploy**

### 添加 Worker 节点

通过添加更多 GPU 节点来扩展集群：

1. 从服务器获取注册令牌：

   ```bash
   docker exec gpustack gpustack show-token
   ```

2. 在另一个节点上启动 Worker：

   ```bash
   docker run -d --name gpustack-worker \
     --gpus all \
     --network host \
     --ipc host \
     -v gpustack-worker-data:/var/lib/gpustack \
     gpustack/gpustack:v0.7.1 \
     gpustack start --server-url http://your-server-ip:80 --token YOUR_TOKEN
   ```

### API 使用

GPUStack 提供与 OpenAI 兼容的 API：

```bash
curl http://localhost:80/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "llama-3.2-3b-instruct",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 功能特性

- **模型管理**：从 Hugging Face、ModelScope 或自定义源部署和管理 LLM 模型
- **GPU 调度**：自动 GPU 分配和负载均衡
- **多后端支持**：支持 llama-box、vLLM 和其他推理后端
- **OpenAI 兼容 API**：可直接替代 OpenAI API
- **Web UI**：用户友好的 Web 界面，用于集群管理
- **监控**：实时资源使用和模型性能指标
- **多节点**：可跨多个 GPU 服务器扩展

## 注意事项

- **生产环境安全**：部署前请更改默认的 `GPUSTACK_BOOTSTRAP_PASSWORD`
- **GPU 要求**：需要支持 CUDA 的 NVIDIA GPU；确保已安装 NVIDIA Container Toolkit
- **磁盘空间**：模型下载可能有数 GB；确保有足够的存储空间
- **首次部署**：初次部署模型可能需要时间来下载模型文件
- **网络**：默认情况下，服务绑定到所有接口（`0.0.0.0`）；在生产环境中请限制访问

## 安全

- **更改默认密码**：首次登录后更新 `GPUSTACK_BOOTSTRAP_PASSWORD`
- **API 密钥**：使用强且唯一的 API 密钥访问 API
- **TLS/HTTPS**：在生产环境中考虑使用带 TLS 的反向代理
- **网络访问**：使用防火墙将访问限制在受信任的网络
- **更新**：保持 GPUStack 更新到最新稳定版本

## 许可证

GPUStack 采用 Apache License 2.0 许可。更多信息请参见 [GPUStack GitHub](https://github.com/gpustack/gpustack)。
