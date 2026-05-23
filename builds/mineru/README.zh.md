# MinerU v2

[English](./README.md) | [中文](./README.zh.md)

此服务运行 MinerU v2。请参阅[参考文档](https://opendatalab.github.io/MinerU/zh/usage/quick_usage/)。

## 启动服务

- **VLM 后端服务器**:

  ```bash
  docker compose --profile vllm-server up -d
  ```

- **文档解析 API**:

  ```bash
  docker compose --profile api up -d
  ```

- **Gradio WebUI**:

  ```bash
  docker compose --profile gradio up -d
  ```

## 测试 vLLM 后端

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```

## 服务

- `mineru-vllm-server`: VLM 后端服务器。
- `mineru-api`: 文档解析 API。
- `mineru-gradio`: Gradio WebUI。

## 配置

- `MINERU_VERSION`: MinerU 的 Docker 镜像版本，默认为 `3.1.0`。
- `MINERU_PORT_OVERRIDE_VLLM`: VLLM 服务器的主机端口，默认为 `30000`。
- `MINERU_PORT_OVERRIDE_API`: API 服务的主机端口，默认为 `8000`。
- `MINERU_PORT_OVERRIDE_GRADIO`: Gradio WebUI 的主机端口，默认为 `7860`。
- `MINERU_API_OUTPUT_ROOT`: API 服务器任务输出的根目录（容器内路径），默认为 `/tmp/mineru-output`。

## 输出路径结构

MinerU API 服务器（`mineru-api`）为每个解析任务创建一个基于 UUID 的子目录，以实现并发请求之间的隔离：

```text
{MINERU_API_OUTPUT_ROOT}/
  {UUID}/
    {filename}/
      auto/            # 或 "vlm"、"hybrid_auto" 等
        {filename}.md
        {filename}_content_list.json
        images/
```

**重要说明**：API 返回的 ZIP 响应会自动去除 UUID 前缀。下游消费者（包括 RAGFlow）收到的文件结构为 `{filename}/{parse_method}/{files}`，不包含任何 UUID。

## RAGFlow 集成

RAGFlow 通过 HTTP API 与 MinerU 集成，使用 `response_format_zip=True` 参数。返回的 ZIP 压缩包**不包含** UUID，RAGFlow 将其解压到临时目录进行处理。

### 常见误解

用户有时会观察到 MinerU 容器内磁盘上的 UUID 路径，并误以为 RAGFlow 无法找到输出文件。但实际上：

1. RAGFlow 通过 HTTP API 与 MinerU 通信，而非共享文件系统。
2. API 返回的 ZIP 文件已去除路径中的 UUID。
3. RAGFlow 内置了强大的多阶段文件查找器，支持多种路径模式作为回退。

### 正确配置

确保 RAGFlow 配置了 MinerU API 端点：

- 在 RAGFlow 环境中设置 `MINERU_APISERVER=http://<mineru-api-host>:8000`。
- 如果使用 VLM 后端，设置 `MINERU_SERVER_URL=http://<mineru-vllm-host>:30000`。

**不要**依赖 RAGFlow 和 MinerU 容器之间的共享文件系统挂载——请使用 HTTP API。

### 不存在的环境变量

以下环境变量**不被** MinerU 识别，设置后无任何效果：

- `MINERU_FLAT_OUTPUT`
- `MAGIC_PDF_FLAT_OUTPUT`
- `ENABLE_TASK_ID_DIR`

这些不属于 MinerU 的配置项。基于 UUID 的任务隔离是架构设计，无法被禁用。
