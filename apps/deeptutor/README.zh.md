# DeepTutor

中文说明 | [English](README.md)

## 概述

DeepTutor 是一个 AI 驱动的个性化学习助手，通过多智能体系统将任何文档转化为交互式学习体验。它可以帮助您解决问题、生成题目、进行研究、协作写作、整理笔记，并引导您完成学习路径。

**项目地址：** <https://github.com/HKUDS/DeepTutor>
**许可证：** Apache-2.0
**文档：** <https://hkuds.github.io/DeepTutor/>

## 功能特性

- **问题求解** — 提供详细的分步解决方案和可视化图表
- **题目生成** — 根据您的知识水平生成自适应题目
- **研究助手** — 通过多智能体协作进行深度研究
- **协作写作** — 交互式创意生成和写作辅助
- **智能笔记** — 高效组织和检索学习材料
- **引导学习** — 个性化学习路径和进度跟踪
- **多智能体系统** — 针对不同学习任务的专业智能体
- **RAG 集成** — 使用 LightRAG 和 RAG-Anything 进行知识检索
- **代码执行** — 内置代码练习环境

## 快速开始

### 前置要求

- Docker 和 Docker Compose
- OpenAI API 密钥（必需）
- 可选：Anthropic、Perplexity 或 DashScope API 密钥

### 安装步骤

1. **克隆仓库**

    ```bash
    git clone <your-compose-anything-repo>
    cd apps/deeptutor
    ```

2. **配置环境变量**

    ```bash
    cp .env.example .env
    # 编辑 .env 文件并添加您的 API 密钥
    ```

    **必需配置：**
    - `OPENAI_API_KEY` — 您的 OpenAI API 密钥

    **可选配置：**
    - `ANTHROPIC_API_KEY` — 用于 Claude 模型
    - `PERPLEXITY_API_KEY` — 用于网络搜索
    - `DASHSCOPE_API_KEY` — 用于阿里云模型
    - 如需调整端口（默认：后端 8001，前端 3782）
    - 云端部署时设置 `NEXT_PUBLIC_API_BASE_EXTERNAL`

3. **可选：自定义智能体配置**

    创建 `config/agents.yaml` 文件以自定义智能体行为（详见[文档](https://hkuds.github.io/DeepTutor/guide/config.html)）。

4. **启动服务**

    ```bash
    docker compose up -d
    ```

    首次运行需要约 30-60 秒初始化。

5. **访问应用**

      - **前端界面：** <http://localhost:3782>
      - **后端 API：** <http://localhost:8001>
      - **API 文档：** <http://localhost:8001/docs>

## 使用方法

### 创建知识库

1. 访问 <http://localhost:3782/knowledge>
2. 点击"新建知识库"
3. 上传文档（支持 PDF、DOCX、TXT、Markdown、HTML 等）
4. 等待处理完成

### 学习模式

- **求解（Solve）** — 获取问题的分步解决方案
- **题目（Question）** — 基于学习材料生成练习题
- **研究（Research）** — 通过多智能体协作进行深度研究
- **协作写作（Co-Writer）** — 交互式写作和创意生成
- **笔记（Notebook）** — 组织和管理学习材料
- **引导（Guide）** — 遵循个性化学习路径

### 高级功能

- **代码执行** — 在界面中直接练习编码
- **可视化图表** — 为复杂概念自动生成图表
- **导出** — 将您的工作下载为 PDF 或 Markdown
- **多语言支持** — 支持多种语言

## 配置说明

### 环境变量

主要环境变量（所有选项见 [.env.example](.env.example)）：

| 变量                     | 默认值   | 描述                 |
| ------------------------ | -------- | -------------------- |
| `OPENAI_API_KEY`         | （必需） | 您的 OpenAI API 密钥 |
| `DEFAULT_MODEL`          | `gpt-4o` | 默认 LLM 模型        |
| `BACKEND_PORT`           | `8001`   | 后端服务器端口       |
| `FRONTEND_PORT`          | `3782`   | 前端应用端口         |
| `DEEPTUTOR_CPU_LIMIT`    | `4.00`   | CPU 限制（核心数）   |
| `DEEPTUTOR_MEMORY_LIMIT` | `8G`     | 内存限制             |

### 端口说明

- **8001** — 后端 API 服务器
- **3782** — 前端 Web 界面

### 数据卷

- `deeptutor_data` — 用户数据、知识库和学习材料
- `./config` — 自定义智能体配置（可选）

## 资源要求

**最低配置：**

- CPU：1 核心
- 内存：2GB
- 磁盘：2GB + 知识库所需空间

**推荐配置：**

- CPU：4 核心
- 内存：8GB
- 磁盘：10GB+

## 支持的模型

DeepTutor 支持多个 LLM 提供商：

- **OpenAI** — GPT-4、GPT-4 Turbo、GPT-3.5 Turbo
- **Anthropic** — Claude 3（Opus、Sonnet、Haiku）
- **Perplexity** — 用于网络搜索集成
- **DashScope** — 阿里云模型
- **OpenAI 兼容 API** — 任何与 OpenAI 格式兼容的 API

## 故障排查

### 后端启动失败

- 验证 `.env` 中的 `OPENAI_API_KEY` 是否正确设置
- 查看日志：`docker compose logs -f`
- 确保端口 8001 和 3782 未被占用
- 验证数据卷有足够的磁盘空间

### 前端无法连接后端

- 确认后端正在运行：访问 <http://localhost:8001/docs>
- 云端部署时，将 `NEXT_PUBLIC_API_BASE_EXTERNAL` 设置为您的公网 URL
- 检查防火墙设置

### 知识库处理失败

- 确保有足够的内存（推荐 8GB+）
- 检查文档格式是否支持
- 查看日志了解具体错误

### API 速率限制

- 在提供商控制台监控 API 使用情况
- 考虑升级 API 计划
- 为不同任务使用不同模型

## 安全提示

- **API 密钥** — 妥善保管您的 API 密钥，切勿提交到版本控制系统
- **网络暴露** — 生产环境部署时，使用 HTTPS 和适当的身份验证
- **数据隐私** — 用户数据存储在 Docker 卷中，请确保适当的备份和安全措施
- **资源限制** — 设置合适的 CPU 和内存限制以防止资源耗尽

## 更新

更新到最新版本：

```bash
# 拉取最新镜像
docker compose pull

# 重新创建容器
docker compose up -d
```

更新到特定版本，编辑 `.env` 中的 `DEEPTUTOR_VERSION` 并运行：

```bash
docker compose up -d
```

## 高级用法

### 自定义智能体配置

创建 `config/agents.yaml` 以自定义智能体行为：

```yaml
agents:
  solver:
    model: gpt-4o
    temperature: 0.7
  researcher:
    model: gpt-4-turbo
    max_tokens: 4000
```

详细配置选项请参见[官方文档](https://hkuds.github.io/DeepTutor/guide/config.html)。

### 云端部署

云端部署需要额外配置：

1. 在 `.env` 中设置公网 URL：

    ```env
    NEXT_PUBLIC_API_BASE_EXTERNAL=https://your-domain.com:8001
    ```

2. 配置反向代理（nginx/Caddy）以支持 HTTPS
3. 确保适当的防火墙规则
4. 考虑使用特定环境的密钥管理

### 使用不同的嵌入模型

DeepTutor 默认使用 `text-embedding-3-large`。要使用不同的嵌入模型，请参考[官方文档](https://hkuds.github.io/DeepTutor/guide/config.html)。

## 相关链接

- **GitHub：** <https://github.com/HKUDS/DeepTutor>
- **文档：** <https://hkuds.github.io/DeepTutor/>
- **问题反馈：** <https://github.com/HKUDS/DeepTutor/issues>
- **讨论区：** <https://github.com/HKUDS/DeepTutor/discussions>

## 许可证

DeepTutor 使用 Apache-2.0 许可证。详情请参见[官方仓库](https://github.com/HKUDS/DeepTutor)。
