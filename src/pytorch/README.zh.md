# PyTorch

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署支持 CUDA、Jupyter Lab 和 TensorBoard 的 PyTorch 深度学习开发环境。

## 服务

- `pytorch`: 支持 GPU、Jupyter Lab 和 TensorBoard 的 PyTorch 容器。

## 先决条件

**需要 NVIDIA GPU**: 此服务需要支持 CUDA 的 NVIDIA GPU 和已安装的 NVIDIA Container Toolkit。

### 安装 NVIDIA Container Toolkit

**Linux:**

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

**Windows (Docker Desktop):**

确保已安装带有 NVIDIA 驱动程序的 WSL2，并将 Docker Desktop 配置为使用 WSL2 后端。

## 环境变量

| 变量名                     | 说明             | 默认值                          |
| -------------------------- | ---------------- | ------------------------------- |
| PYTORCH_VERSION            | PyTorch 镜像版本 | `2.6.0-cuda12.6-cudnn9-runtime` |
| JUPYTER_ENABLE_LAB         | 启用 Jupyter Lab | `yes`                           |
| JUPYTER_TOKEN              | Jupyter 访问令牌 | `pytorch`                       |
| NVIDIA_VISIBLE_DEVICES     | 使用的 GPU       | `all`                           |
| NVIDIA_DRIVER_CAPABILITIES | 驱动程序功能     | `compute,utility`               |
| GPU_COUNT                  | 分配的 GPU 数量  | `1`                             |
| JUPYTER_PORT_OVERRIDE      | Jupyter Lab 端口 | `8888`                          |
| TENSORBOARD_PORT_OVERRIDE  | TensorBoard 端口 | `6006`                          |

请根据实际需求修改 `.env` 文件。

## 卷

- `pytorch_notebooks`: Jupyter 笔记本和脚本。
- `pytorch_data`: 训练数据和数据集。

## 使用方法

### 启动服务

```bash
docker-compose up -d
```

### 访问 Jupyter Lab

在浏览器中打开:

```text
http://localhost:8888
```

使用 `JUPYTER_TOKEN` 中指定的令牌登录（默认: `pytorch`）。

### 验证 GPU 访问

在 Jupyter 笔记本中:

```python
import torch

print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")
print(f"Number of GPUs: {torch.cuda.device_count()}")

if torch.cuda.is_available():
    print(f"GPU name: {torch.cuda.get_device_name(0)}")
```

### 训练脚本示例

```python
import torch
import torch.nn as nn
import torch.optim as optim

# 设置设备
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# 定义简单模型
model = nn.Sequential(
    nn.Linear(784, 128),
    nn.ReLU(),
    nn.Linear(128, 10)
).to(device)

# 创建虚拟数据
x = torch.randn(64, 784).to(device)
y = torch.randint(0, 10, (64,)).to(device)

# 训练
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters())

output = model(x)
loss = criterion(output, y)
loss.backward()
optimizer.step()

print(f"Loss: {loss.item()}")
```

### 访问 TensorBoard

TensorBoard 端口已暴露，但需要手动启动:

```python
from torch.utils.tensorboard import SummaryWriter
writer = SummaryWriter('/workspace/runs')
```

然后启动 TensorBoard:

```bash
docker exec pytorch tensorboard --logdir=/workspace/runs --host=0.0.0.0
```

访问地址: `http://localhost:6006`

## 功能

- **GPU 加速**: CUDA 支持以实现快速训练
- **Jupyter Lab**: 交互式开发环境
- **TensorBoard**: 训练指标的可视化
- **预安装**: PyTorch、CUDA、cuDNN 即可使用
- **持久存储**: 笔记本和数据存储在卷中

## 注意事项

- GPU 对于最佳性能是必需的
- 推荐: 大多数深度学习任务需要 8GB+ 显存
- 容器在首次启动时安装 Jupyter 和 TensorBoard
- 使用 `pytorch/pytorch:*-devel` 构建自定义扩展
- 对于多 GPU 训练，调整 `GPU_COUNT` 并使用 `torch.nn.DataParallel`

## 许可证

PyTorch 使用 BSD 风格许可证授权。
