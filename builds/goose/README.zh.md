# goose

[English Documentation](README.md)

goose 是由 Block 公司开发的 AI 驱动的开发者助手。它通过自然语言交互帮助开发者完成编码任务，提供智能代码生成、调试协助和项目导航功能。

## 功能特性

- **AI 驱动开发**：利用先进的语言模型提供编程协助
- **多 AI 提供商支持**：支持 OpenAI、Anthropic 和 Google AI
- **交互式 CLI**：通过直观的命令行界面与 goose 交互
- **项目理解**：分析和理解您的代码库上下文
- **代码生成**：生成代码片段和实现
- **调试帮助**：协助故障排查和错误解决

## 前置要求

- 已安装 Docker 和 Docker Compose
- 来自受支持的 AI 提供商之一的 API 密钥：
  - OpenAI API 密钥（用于 GPT 模型）
  - Anthropic API 密钥（用于 Claude 模型）
  - Google API 密钥（用于 Gemini 模型）

## 快速开始

1. 复制示例环境文件：

    ```bash
    cp .env.example .env
    ```

2. 编辑 `.env` 并配置您的 API 凭据：

    ```bash
    # 使用 OpenAI
    OPENAI_API_KEY=your_openai_api_key_here
    GOOSE_PROVIDER=openai
    GOOSE_MODEL=gpt-4

    # 或使用 Anthropic
    ANTHROPIC_API_KEY=your_anthropic_api_key_here
    GOOSE_PROVIDER=anthropic
    GOOSE_MODEL=claude-3-sonnet

    # 或使用 Google
    GOOGLE_API_KEY=your_google_api_key_here
    GOOSE_PROVIDER=google
    GOOSE_MODEL=gemini-pro
    ```

3. 构建 Docker 镜像：

    ```bash
    docker compose build
    ```

4. 运行 goose：

    ```bash
    docker compose run --rm goose
    ```

## 使用示例

### 交互式会话

启动与 goose 的交互式会话：

```bash
docker compose run --rm goose session start
```

### 执行任务

运行特定任务或查询：

```bash
docker compose run --rm goose run "解释 app.py 中的主函数"
```

### 获取帮助

查看可用命令：

```bash
docker compose run --rm goose --help
```

## 配置说明

### 环境变量

| 变量                 | 说明                                   | 默认值   |
| -------------------- | -------------------------------------- | -------- |
| `GOOSE_VERSION`      | goose Docker 镜像版本                  | `1.18.0` |
| `TZ`                 | 容器时区                               | `UTC`    |
| `GOOSE_PROVIDER`     | AI 提供商（openai、anthropic、google） | `openai` |
| `GOOSE_MODEL`        | 使用的 AI 模型                         | `gpt-4`  |
| `OPENAI_API_KEY`     | OpenAI API 密钥                        | -        |
| `OPENAI_API_BASE`    | 自定义 OpenAI API 基础 URL             | -        |
| `ANTHROPIC_API_KEY`  | Anthropic API 密钥                     | -        |
| `GOOGLE_API_KEY`     | Google API 密钥                        | -        |
| `GOOSE_CPU_LIMIT`    | CPU 限制                               | `2.00`   |
| `GOOSE_MEMORY_LIMIT` | 内存限制                               | `2G`     |

### 使用您的项目

挂载您的项目目录以使用您的代码：

```bash
docker compose run --rm -v $(pwd):/workspace goose
```

或将其添加到 `docker-compose.yaml` 的 volumes 部分：

```yaml
volumes:
  - ./your-project:/workspace
  - goose_config:/home/goose/.config/goose
```

## 持久化配置

配置和会话数据存储在命名卷中：

- `goose_config`：用户配置和偏好设置
- `goose_workspace`：工作区文件和项目数据

重置配置：

```bash
docker compose down -v
```

## 资源限制

默认资源分配：

- **CPU 限制**：2.00 核心
- **CPU 预留**：0.50 核心
- **内存限制**：2G
- **内存预留**：512M

根据您的系统能力在 `.env` 中调整这些值。

## 安全注意事项

1. **API 密钥**：切勿将包含 API 密钥的 `.env` 文件提交到版本控制系统
2. **工作区访问**：goose 可以访问挂载的工作区目录中的文件
3. **网络**：默认情况下容器不暴露端口
4. **用户权限**：以非 root 用户（UID 1000）运行以增强安全性

## 支持的 AI 模型

### OpenAI

- `gpt-4`（推荐）
- `gpt-4-turbo`
- `gpt-3.5-turbo`

### Anthropic

- `claude-3-opus`
- `claude-3-sonnet`（推荐）
- `claude-3-haiku`

### Google

- `gemini-pro`

## 故障排查

### API 认证错误

确保您的 API 密钥在 `.env` 中正确设置，并与您选择的提供商匹配。

### 内存不足

如果遇到内存问题，请在 `.env` 中增加 `GOOSE_MEMORY_LIMIT`。

### 构建失败

初始构建可能需要 15-30 分钟，因为它从源代码编译 goose。请确保您有稳定的互联网连接。

## 参考资料

- [官方 GitHub 仓库](https://github.com/block/goose)
- [文档](https://block.github.io/goose/)
- [贡献指南](https://github.com/block/goose/blob/main/CONTRIBUTING.md)

## 许可证

goose 在 Apache-2.0 许可证下发布。详情请参阅[官方仓库](https://github.com/block/goose)。

此 Docker Compose 配置按原样提供以方便使用，并遵循项目的许可条款。
