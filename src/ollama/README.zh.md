# Ollama

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Ollama，本地运行大语言模型。

## 用法

- 拉取 DeepSeek R1 7B 模型：

  ```bash
  docker exec -it ollama ollama pull deepseek-r1:7b
  ```

- 列出本地所有模型：

  ```bash
  docker exec -it ollama ollama list
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
