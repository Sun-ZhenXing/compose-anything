# LMDeploy Docker Compose

[LMDeploy](https://github.com/InternLM/lmdeploy) 是一个用于压缩、部署和服务大语言模型（LLM）的工具包。

## 快速开始

1. （可选）在 `.env` 中配置模型和端口。
2. 启动服务：
   ```bash
   docker compose up -d
   ```
3. 通过 `http://localhost:23333/v1` 访问与 OpenAI 兼容的 API。

## 配置项

| 环境变量                 | 默认值                         | 说明                                 |
| ------------------------ | ------------------------------ | ------------------------------------ |
| `LMDEPLOY_VERSION`       | `v0.11.1-cu12.8`               | LMDeploy 镜像版本                    |
| `LMDEPLOY_PORT_OVERRIDE` | `23333`                        | API 服务器的主机端口                 |
| `LMDEPLOY_MODEL`         | `internlm/internlm2-chat-1_8b` | HuggingFace 模型 ID 或本地路径       |
| `HF_TOKEN`               |                                | 用于访问私有模型的 HuggingFace Token |

## 健康检查

该配置包含健康检查，用于验证 OpenAI `/v1/models` 接口是否响应。

## GPU 支持

默认情况下，此配置会预留 1 个 NVIDIA GPU。请确保您的主机已安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)。
