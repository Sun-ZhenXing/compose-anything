# Nanobot

[中文说明](README.zh.md) | [English](README.md)

Nanobot 是一个轻量级、生产就绪的个人 AI 助手，支持多渠道（Telegram、Discord、WhatsApp、飞书），本地模型集成，以及强大的工具能力。

## 特性

- 🤖 **多 LLM 提供商支持**：OpenRouter、Anthropic、OpenAI、DeepSeek、Groq、Gemini 等
- 🖥️ **本地模型**：使用 vLLM 或任何 OpenAI 兼容服务器运行您自己的模型
- 💬 **多渠道**：集成 Telegram、Discord、WhatsApp 和飞书
- 🛠️ **强大工具**：文件操作、Shell 执行、网络搜索和自定义技能
- 📅 **定时任务**：支持自然语言的类 Cron 任务调度
- 🎯 **记忆与技能**：持久化记忆和可扩展技能系统
- 🔒 **安全性**：沙盒模式、访问控制和安全命令执行

## 快速开始

### 前置要求

- 已安装 Docker 和 Docker Compose
- 至少一个 LLM 提供商 API 密钥（推荐：[OpenRouter](https://openrouter.ai/keys)）

### 配置步骤

1. **复制环境变量示例文件：**

    ```bash
    cp .env.example .env
    ```

2. **编辑 `.env` 并至少配置一个 LLM 提供商：**

    ```bash
    # 使用 OpenRouter（推荐，可访问所有模型）
    OPENROUTER_API_KEY=sk-or-v1-xxxxx

    # 或使用其他提供商
    ANTHROPIC_API_KEY=sk-ant-xxxxx
    OPENAI_API_KEY=sk-xxxxx
    ```

3. **启动服务：**

    ```bash
    docker compose up -d
    ```

4. **初始化配置（仅首次需要）：**

    ```bash
    docker compose exec nanobot nanobot onboard
    ```

5. **检查状态：**

    ```bash
    docker compose exec nanobot nanobot status
    ```

## 使用方法

### CLI 模式

直接与 nanobot 对话：

```bash
docker compose exec nanobot nanobot agent -m "2+2 等于多少？"
```

交互模式：

```bash
docker compose exec nanobot nanobot agent
```

### 网关模式（默认）

默认的 `docker compose up` 会启动网关服务器，支持：

- Telegram 机器人集成
- Discord 机器人集成
- WhatsApp 消息（需要额外配置）
- 飞书 / Lark 集成
- HTTP API 访问（端口 18790）

### 渠道配置

#### Telegram

1. 通过 Telegram 上的 [@BotFather](https://t.me/BotFather) 创建机器人
2. 从 [@userinfobot](https://t.me/userinfobot) 获取您的用户 ID
3. 在 `.env` 中配置：

    ```bash
    TELEGRAM_ENABLED=true
    TELEGRAM_TOKEN=你的机器人令牌
    ```

4. 重启服务

#### Discord

1. 在 [Discord 开发者门户](https://discord.com/developers/applications) 创建机器人
2. 在机器人设置中启用 **MESSAGE CONTENT INTENT**
3. 在 `.env` 中配置：

    ```bash
    DISCORD_ENABLED=true
    DISCORD_TOKEN=你的机器人令牌
    ```

4. 重启服务

#### WhatsApp

需要 Node.js 和额外配置。详见 [官方文档](https://github.com/HKUDS/nanobot#-chat-apps)。

#### 飞书

1. 在 [飞书开放平台](https://open.feishu.cn/app) 创建应用
2. 启用机器人能力并添加 `im:message` 权限
3. 在 `.env` 中配置：

    ```bash
    FEISHU_ENABLED=true
    FEISHU_APP_ID=你的应用ID
    FEISHU_APP_SECRET=你的应用密钥
    ```

4. 重启服务

## 配置

### 环境变量

所有可用配置选项请参见 [.env.example](.env.example)。

关键设置：

| 变量                    | 描述                                   | 默认值                      |
| ----------------------- | -------------------------------------- | --------------------------- |
| `NANOBOT_MODEL`         | 要使用的 LLM 模型                      | `anthropic/claude-opus-4-5` |
| `NANOBOT_COMMAND`       | 要运行的命令（gateway、agent、status） | `gateway`                   |
| `RESTRICT_TO_WORKSPACE` | 沙盒模式 - 限制工具访问工作空间        | `false`                     |
| `BRAVE_API_KEY`         | 网络搜索工具的 API 密钥                | （空）                      |
| `TELEGRAM_ENABLED`      | 启用 Telegram 渠道                     | `false`                     |
| `DISCORD_ENABLED`       | 启用 Discord 渠道                      | `false`                     |

### LLM 提供商优先级

当配置了多个提供商时，nanobot 将：

1. 根据模型名称匹配提供商（例如 `gpt-4` → OpenAI）
2. 回退到第一个可用的 API 密钥

### 安全性

对于生产部署：

- 设置 `RESTRICT_TO_WORKSPACE=true` 以沙盒化所有文件和 Shell 操作
- 在配置文件中为渠道访问控制配置 `allowFrom` 列表
- 为渠道集成使用专用用户账户
- 监控 API 使用并设置支出限制
- 将凭证保存在环境变量中，绝不在代码中

## 定时任务

按计划运行任务：

```bash
# 添加每日提醒
docker compose exec nanobot nanobot cron add \
  --name "morning" \
  --message "早上好！今天有什么安排？" \
  --cron "0 9 * * *"

# 列出计划任务
docker compose exec nanobot nanobot cron list

# 删除任务
docker compose exec nanobot nanobot cron remove <job_id>
```

## 本地模型（vLLM）

使用您自己的本地模型运行 nanobot：

1. **启动 vLLM 服务器：**

    ```bash
    vllm serve meta-llama/Llama-3.1-8B-Instruct --port 8000
    ```

2. **在 `.env` 中配置：**

    ```bash
    VLLM_API_KEY=dummy
    VLLM_API_BASE=http://host.docker.internal:8000/v1
    NANOBOT_MODEL=meta-llama/Llama-3.1-8B-Instruct
    ```

3. **重启服务**

## 数据卷

- `nanobot_config`：配置文件和凭证
- `nanobot_workspace`：代理工作空间和文件

## 端口

- `18790`：网关 HTTP API（可通过 `NANOBOT_PORT_OVERRIDE` 配置）

## 资源限制

默认资源限制：

- CPU：1.0 核心（限制），0.5 核心（预留）
- 内存：1GB（限制），512MB（预留）

通过环境变量调整：`NANOBOT_CPU_LIMIT`、`NANOBOT_MEMORY_LIMIT` 等。

## 故障排除

### 查看日志

```bash
docker compose logs -f nanobot
```

### 验证配置

```bash
docker compose exec nanobot nanobot status
```

### 测试 LLM 连接

```bash
docker compose exec nanobot nanobot agent -m "你好！"
```

### 常见问题

**未配置 API 密钥：**

- 确保在 `.env` 中至少设置了一个提供商 API 密钥
- 更新环境变量后重启服务

**渠道无响应：**

- 检查渠道是否在 `.env` 中启用
- 验证机器人令牌是否正确
- 检查日志中的连接错误

**文件权限错误：**

- 确保数据卷具有适当的权限
- 调试时尝试使用 `RESTRICT_TO_WORKSPACE=false` 运行

## 许可证

Nanobot 是一个开源项目。许可证详情请参见 [官方仓库](https://github.com/HKUDS/nanobot)。

## 链接

- 官方仓库：<https://github.com/HKUDS/nanobot>
- 文档：<https://github.com/HKUDS/nanobot#readme>
- 问题反馈：<https://github.com/HKUDS/nanobot/issues>
