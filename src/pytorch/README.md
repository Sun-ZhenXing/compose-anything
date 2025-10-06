# PyTorch

[English](./README.md) | [中文](./README.zh.md)

This service deploys PyTorch with CUDA support, Jupyter Lab, and TensorBoard for deep learning development.

## Services

- `pytorch`: PyTorch container with GPU support, Jupyter Lab, and TensorBoard.

## Prerequisites

**NVIDIA GPU Required**: This service requires an NVIDIA GPU with CUDA support and the NVIDIA Container Toolkit installed.

### Install NVIDIA Container Toolkit

**Linux:**

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

**Windows (Docker Desktop):**

Ensure you have WSL2 with NVIDIA drivers installed and Docker Desktop configured to use WSL2 backend.

## Environment Variables

| Variable Name              | Description                | Default Value                   |
| -------------------------- | -------------------------- | ------------------------------- |
| PYTORCH_VERSION            | PyTorch image version      | `2.6.0-cuda12.6-cudnn9-runtime` |
| JUPYTER_ENABLE_LAB         | Enable Jupyter Lab         | `yes`                           |
| JUPYTER_TOKEN              | Jupyter access token       | `pytorch`                       |
| NVIDIA_VISIBLE_DEVICES     | GPUs to use                | `all`                           |
| NVIDIA_DRIVER_CAPABILITIES | Driver capabilities        | `compute,utility`               |
| GPU_COUNT                  | Number of GPUs to allocate | `1`                             |
| JUPYTER_PORT_OVERRIDE      | Jupyter Lab port           | `8888`                          |
| TENSORBOARD_PORT_OVERRIDE  | TensorBoard port           | `6006`                          |

Please modify the `.env` file as needed for your use case.

## Volumes

- `pytorch_notebooks`: Jupyter notebooks and scripts.
- `pytorch_data`: Training data and datasets.

## Usage

### Start the Service

```bash
docker-compose up -d
```

### Access Jupyter Lab

Open your browser and navigate to:

```text
http://localhost:8888
```

Login with the token specified in `JUPYTER_TOKEN` (default: `pytorch`).

### Verify GPU Access

In a Jupyter notebook:

```python
import torch

print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")
print(f"Number of GPUs: {torch.cuda.device_count()}")

if torch.cuda.is_available():
    print(f"GPU name: {torch.cuda.get_device_name(0)}")
```

### Example Training Script

```python
import torch
import torch.nn as nn
import torch.optim as optim

# Set device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Define a simple model
model = nn.Sequential(
    nn.Linear(784, 128),
    nn.ReLU(),
    nn.Linear(128, 10)
).to(device)

# Create dummy data
x = torch.randn(64, 784).to(device)
y = torch.randint(0, 10, (64,)).to(device)

# Training
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters())

output = model(x)
loss = criterion(output, y)
loss.backward()
optimizer.step()

print(f"Loss: {loss.item()}")
```

### Access TensorBoard

TensorBoard port is exposed but needs to be started manually:

```python
from torch.utils.tensorboard import SummaryWriter
writer = SummaryWriter('/workspace/runs')
```

Then start TensorBoard:

```bash
docker exec pytorch tensorboard --logdir=/workspace/runs --host=0.0.0.0
```

Access at: `http://localhost:6006`

## Features

- **GPU Acceleration**: CUDA support for fast training
- **Jupyter Lab**: Interactive development environment
- **TensorBoard**: Visualization for training metrics
- **Pre-installed**: PyTorch, CUDA, cuDNN ready to use
- **Persistent Storage**: Notebooks and data stored in volumes

## Notes

- GPU is required for optimal performance
- Recommended: 8GB+ VRAM for most deep learning tasks
- The container installs Jupyter and TensorBoard on first start
- Use `pytorch/pytorch:*-devel` for building custom extensions
- For multi-GPU training, adjust `GPU_COUNT` and use `torch.nn.DataParallel`

## License

PyTorch is licensed under the BSD-style license.
