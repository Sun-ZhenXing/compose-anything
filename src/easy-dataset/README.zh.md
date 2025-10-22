# Easy Dataset

[English](./README.md) | [中文](./README.zh.md)

这个服务部署 Easy Dataset，一个用于创建大语言模型（LLM）微调数据集的强大工具。它提供了直观的界面，可以上传特定领域的文件、智能分割内容、生成问题，并产生高质量的模型微调训练数据。

## 服务

- `easy-dataset`：主应用服务器，内置 SQLite 数据库。

## 环境变量

| 变量名                     | 描述                   | 默认值  |
| -------------------------- | ---------------------- | ------- |
| EASY_DATASET_VERSION       | Easy Dataset 镜像版本  | `1.5.1` |
| EASY_DATASET_PORT_OVERRIDE | Web 界面的主机端口映射 | `1717`  |
| TZ                         | 系统时区               | `UTC`   |

请创建 `.env` 文件并根据您的使用场景进行修改。

## 数据卷

- `easy_dataset_db`：用于存储 SQLite 数据库和上传文件的命名卷。
- `easy_dataset_prisma`：（可选）如需要可用于 Prisma 数据库文件的命名卷。

## 快速开始

### 快速启动（推荐）

1. （可选）创建 `.env` 文件以自定义设置：

   ```env
   EASY_DATASET_VERSION=1.5.1
   EASY_DATASET_PORT_OVERRIDE=1717
   TZ=Asia/Shanghai
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 访问 Easy Dataset：`http://localhost:1717`

### 使用 Prisma 数据库挂载（高级）

如果需要挂载 Prisma 数据库文件：

1. 首先初始化数据库：

   ```bash
   # 克隆仓库并初始化数据库
   git clone https://github.com/ConardLi/easy-dataset.git
   cd easy-dataset
   npm install
   npm run db:push
   ```

2. 在 `docker-compose.yaml` 中取消注释 Prisma 卷挂载：

   ```yaml
   volumes:
     - easy_dataset_db:/app/local-db
     - easy_dataset_prisma:/app/prisma  # 取消此行注释
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

## 功能特性

- **智能文档处理**：支持 PDF、Markdown、DOCX 等多种格式
- **智能文本分割**：多种算法，可自定义分段
- **问题生成**：从文本中自动提取相关问题
- **领域标签**：构建全局领域标签，具有理解能力
- **答案生成**：使用 LLM API 生成全面的答案和思维链（COT）
- **灵活编辑**：在任何阶段编辑问题、答案和数据集
- **多种导出格式**：Alpaca、ShareGPT、multilingual-thinking（JSON/JSONL）
- **广泛的模型支持**：兼容所有遵循 OpenAI 格式的 LLM API

## 使用流程

1. **创建项目**：设置新项目并配置 LLM API
2. **上传文档**：添加您的特定领域文件（PDF、Markdown 等）
3. **文本分割**：查看并调整自动分割的文本段
4. **生成问题**：从文本块批量构造问题
5. **创建数据集**：使用配置的 LLM 生成答案
6. **导出**：以您喜欢的格式导出数据集

## 默认凭据

Easy Dataset 默认不需要身份验证。应在基础设施层面实现访问控制（例如反向代理、防火墙规则）。

## 资源限制

该服务配置了以下资源限制：

- **CPU**：0.5-2.0 核心
- **内存**：1-4 GB

可以根据您的工作负载需求在 `docker-compose.yaml` 中调整这些限制。

## 安全注意事项

- **数据隐私**：所有数据处理都在本地进行
- **API 密钥**：在应用程序内安全存储 LLM API 密钥
- **访问控制**：根据需要实施网络级访问限制
- **更新**：定期更新到最新版本以获取安全补丁

## 文档

- 官方文档：[https://docs.easy-dataset.com/](https://docs.easy-dataset.com/)
- GitHub 仓库：[https://github.com/ConardLi/easy-dataset](https://github.com/ConardLi/easy-dataset)
- 视频教程：[Bilibili](https://www.bilibili.com/video/BV1y8QpYGE57/)
- 研究论文：[arXiv:2507.04009](https://arxiv.org/abs/2507.04009v1)

## 故障排除

### 容器无法启动

- 查看日志：`docker compose logs easy-dataset`
- 验证端口 1717 未被占用
- 确保系统资源充足

### 数据库问题

- 如遇到 SQLite 问题，删除并重新创建卷：

  ```bash
  docker compose down -v
  docker compose up -d
  ```

### 权限错误

- 确保容器对挂载卷有写入权限
- 检查 Docker 卷权限

## 许可证

Easy Dataset 采用 AGPL 3.0 许可证。详见 [LICENSE](https://github.com/ConardLi/easy-dataset/blob/main/LICENSE) 文件。
