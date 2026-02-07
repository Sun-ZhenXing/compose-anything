# OpenClaw

OpenClaw 是一个运行在你自己设备上的个人 AI 助手。它集成了多个消息平台（WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、WebChat），并在所有频道上提供 AI 驱动的帮助。

## 功能特性

- **多频道支持**：WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、BlueBubbles、Microsoft Teams、Matrix、Zalo、WebChat
- **本地优先网关**：会话、频道、工具和事件的统一控制平面
- **多代理路由**：将入站频道路由到具有独立会话的隔离代理
- **语音唤醒 + 对话模式**：macOS/iOS/Android 上的永久在线语音支持（使用 ElevenLabs）
- **实时画布**：由代理驱动的可视化工作空间，支持 A2UI
- **一流工具**：浏览器、画布、节点、定时任务、会话和特定频道的操作
- **配套应用**：macOS 菜单栏应用 + iOS/Android 节点
- **技能平台**：内置、托管和工作区技能，支持安装门控

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 生成安全的网关令牌：

   ```bash
   # 使用 OpenSSL
   openssl rand -hex 32
   
   # 或使用 Python
   python3 -c "import secrets; print(secrets.token_hex(32))"
   ```

3. 编辑 `.env` 文件，至少设置：
   - `OPENCLAW_GATEWAY_TOKEN` - 你生成的令牌
   - `ANTHROPIC_API_KEY` 或 `OPENAI_API_KEY` - 如果使用 API 密钥认证

4. 启动网关：

   ```bash
   docker compose up -d
   ```

5. 访问控制界面：
   - 在浏览器中打开 <http://localhost:18789>
   - 在提示时输入你的网关令牌

## 配置

### 网关访问

网关可以通过两种方式访问：

- **回环地址**（`OPENCLAW_GATEWAY_BIND=loopback`）：仅从主机访问（127.0.0.1）
- **局域网**（`OPENCLAW_GATEWAY_BIND=lan`）：从本地网络访问（0.0.0.0）

对于生产部署，建议：

- 使用 Tailscale Serve/Funnel 进行安全的远程访问
- 设置 SSH 隧道
- 实现带认证的反向代理

### 模型配置

OpenClaw 支持多个 AI 模型提供商：

- **Anthropic Claude**（推荐）：Claude Pro/Max，支持 OAuth 或 API 密钥
- **OpenAI**：ChatGPT/Codex，支持 OAuth 或 API 密钥
- **自定义提供商**：通过控制界面或配置文件进行配置

在 `.env` 文件中设置 API 密钥，或通过入门向导使用 OAuth 认证。

### 频道集成

连接消息平台：

1. **WhatsApp**：使用 CLI 链接设备

   ```bash
   docker compose run --rm moltbot-cli channels login
   ```

2. **Telegram**：在配置中设置 `TELEGRAM_BOT_TOKEN`

3. **Discord**：在配置中设置 `DISCORD_BOT_TOKEN`

4. **Slack**：在配置中设置 `SLACK_BOT_TOKEN` 和 `SLACK_APP_TOKEN`

详细设置说明请参阅[官方文档](https://docs.openclaw.bot/channels)。

## 使用命令行界面

CLI 服务可通过 `cli` 配置文件使用：

```bash
# 运行入门向导
docker compose run --rm --service-ports openclaw-cli onboard

# 列出提供商
docker compose run --rm openclaw-cli providers list

# 发送消息
docker compose run --rm openclaw-cli message send --to +1234567890 --message "你好"

# 检查健康状态
docker compose run --rm openclaw-cli health --port 18789
```

## 安全注意事项

1. **网关令牌**：保护好你的网关令牌。这是控制界面和 WebSocket 连接的认证方式。

2. **私信访问**：默认情况下，OpenClaw 对来自未知发送者的私信使用配对模式。他们会收到一个配对码，你必须批准。

3. **网络暴露**：如果在 localhost 之外暴露网关，请使用适当的认证和加密：
   - 设置 Tailscale 进行安全的远程访问
   - 使用 SSH 隧道
   - 实现带 HTTPS 和认证的反向代理

4. **API 密钥**：永远不要将 API 密钥提交到版本控制。使用 `.env` 文件或密钥管理。

5. **沙箱模式**：为了群组/频道安全，启用沙箱模式以在 Docker 容器中运行非主会话。

## 高级配置

### 资源限制

在 `.env` 文件中调整 CPU 和内存限制：

```env
OPENCLAW_CPU_LIMIT=2.0
OPENCLAW_MEMORY_LIMIT=2G
OPENCLAW_CPU_RESERVATION=1.0
OPENCLAW_MEMORY_RESERVATION=1G
```

### 持久化数据

数据存储在两个 Docker 卷中：

- `openclaw_config`：配置文件和凭据（~/.openclaw）
- `openclaw_workspace`：代理工作区和技能（~/openclaw-workspace）

备份数据：

```bash
docker run --rm -v openclaw_config:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-config-backup.tar.gz /data
docker run --rm -v openclaw_workspace:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-workspace-backup.tar.gz /data
```

### 自定义配置文件

在 `~/.openclaw/openclaw.json`（容器内）创建自定义配置文件：

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-5",
        "fallbacks": ["anthropic/claude-sonnet-4-5", "openai/gpt-4o"]
      }
    }
  }
}
```

## 故障排除

### 网关无法启动

1. 检查日志：`docker compose logs openclaw-gateway`
2. 验证网关令牌是否在 `.env` 中设置
3. 确保端口 18789 未被占用

### 无法访问控制界面

1. 验证网关绑定设置是否与你的访问方式匹配
2. 如果从另一台机器访问，检查防火墙规则
3. 确保容器健康：`docker compose ps`

### 模型 API 错误

1. 验证 API 密钥是否在 `.env` 中正确设置
2. 检查 API 密钥有效性和配额
3. 查看日志中的具体错误消息

### 运行诊断命令

诊断命令可帮助诊断常见问题：

```bash
docker compose run --rm openclaw-cli doctor
```

## 文档

- [官方网站](https://openclaw.bot)
- [完整文档](https://docs.openclaw.bot)
- [入门指南](https://docs.openclaw.bot/start/getting-started)
- [配置参考](https://docs.openclaw.bot/gateway/configuration)
- [安全指南](https://docs.openclaw.bot/gateway/security)
- [Docker 安装](https://docs.openclaw.bot/install/docker)
- [GitHub 仓库](https://github.com/openclaw/openclaw)

## 许可证

OpenClaw 使用 MIT 许可证发布。详情请参阅 [LICENSE](https://github.com/openclaw/openclaw/blob/main/LICENSE) 文件。

## 社区

- [Discord](https://discord.gg/clawd)
- [GitHub 讨论](https://github.com/openclaw/openclaw/discussions)
- [问题跟踪](https://github.com/openclaw/openclaw/issues)
