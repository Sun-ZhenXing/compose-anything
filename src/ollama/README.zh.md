# Ollama

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Ollama，本地运行大语言模型。

## 用法

- 拉取 DeepSeek R1 7B 模型：

  ```bash
  docker exec -it ollama-ollama-1 ollama pull deepseek-r1:7b
  ```

- 列出本地所有模型：

  ```bash
  docker exec -it ollama-ollama-1 ollama list
  ```

- 通过 API 获取本地所有模型：

  ```bash
  curl http://localhost:11434/api/tags 2> /dev/null | jq
  ```

## 服务

- `ollama`: Ollama 服务。

## 配置

- `OLLAMA_VERSION`: Ollama 镜像的版本，默认为 `0.12.0`。
- `OLLAMA_PORT_OVERRIDE`: Ollama 的主机端口，默认为 `11434`。

## 卷

- `ollama_models`: 用于存储 Ollama 模型的卷。

## 故障排除

### 长时间运行后 GPU 离线（Linux Docker）

如果 Ollama 在 Docker 容器中最初可以正常使用 GPU，但运行一段时间后切换到 CPU 运行，且服务器日志中报告 GPU 发现失败的错误，可以通过禁用 Docker 的 systemd cgroup 管理来解决此问题。

编辑主机上的 `/etc/docker/daemon.json` 文件，添加 `"exec-opts": ["native.cgroupdriver=cgroupfs"]` 到 Docker 配置中：

```json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
```

然后重启 Docker：

```bash
sudo systemctl restart docker
```

更多详情请参阅 [Ollama 故障排除 - Linux Docker](https://docs.ollama.com/troubleshooting#linux-docker)。
