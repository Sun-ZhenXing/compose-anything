# RAGFlow

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://ragflow.io/docs>。

此服务用于部署 RAGFlow，一个基于深度文档理解的开源检索增强生成引擎。它能对复杂文档（PDF、Word、PowerPoint 等）进行智能问答，并提供精准的引用和引文追踪。

> **平台说明**：此 Stack 仅支持 **x86-64（amd64）**，官方镜像不支持 ARM64。
>
> **资源说明**：仅 Elasticsearch 就需要约 2 GB RAM，启动前请确保系统至少有 **8 GB RAM**。

## 服务

- **ragflow**：RAGFlow Web 应用和 API 服务器（Nginx 监听 80 端口，API 监听 9380 端口）。
- **es01**：单节点 Elasticsearch 集群，用于向量和全文检索。
- **mysql**：MySQL 8 数据库，用于元数据和工作流状态存储。
- **redis**：Redis，用于任务队列和缓存。
- **minio**：S3 兼容对象存储，用于文档和分块存储。

## 快速开始

1. 将 `.env.example` 复制为 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 更新 `.env` 中的密钥：

   ```
   SECRET_KEY、MYSQL_PASSWORD、REDIS_PASSWORD、MINIO_PASSWORD
   ```

3. 启动服务（首次启动可能需要 2～5 分钟）：

   ```bash
   docker compose up -d
   ```

4. 打开 `http://localhost`，注册第一个管理员账号。

## 核心环境变量

| 变量                          | 说明                                       | 默认值        |
| ----------------------------- | ------------------------------------------ | ------------- |
| `RAGFLOW_VERSION`             | RAGFlow 镜像版本                           | `v0.24.0`     |
| `RAGFLOW_PORT_OVERRIDE`       | Web UI 宿主机端口                          | `80`          |
| `SECRET_KEY`                  | 应用密钥——**请修改**                       | 占位符        |
| `MYSQL_PASSWORD`              | MySQL root 密码（也供 RAGFlow 使用）       | `ragflow`     |
| `REDIS_PASSWORD`              | Redis 认证密码                             | `redispassword` |
| `MINIO_USER`                  | MinIO root 用户名                          | `minioadmin`  |
| `MINIO_PASSWORD`              | MinIO root 密码                            | `minioadmin`  |
| `MINIO_CONSOLE_PORT_OVERRIDE` | MinIO Web 控制台宿主机端口                 | `9001`        |

## 数据卷

- `ragflow_logs`：RAGFlow 应用日志。
- `ragflow_es_data`：Elasticsearch 索引数据。
- `ragflow_mysql_data`：MySQL 数据库文件。
- `ragflow_redis_data`：Redis 持久化数据。
- `ragflow_minio_data`：文档和嵌入向量的对象存储。

## 端口

- **80**：RAGFlow Web UI 和 API（通过 Nginx）
- **9001**：MinIO Web 控制台

## 资源需求

| 服务          | CPU 限制 | 内存限制 |
| ------------- | -------- | -------- |
| ragflow       | 4        | 4 GB     |
| elasticsearch | 2        | 2 GB     |
| mysql         | 1        | 1 GB     |
| redis         | 0.5      | 512 MB   |
| minio         | 1        | 1 GB     |

推荐总计：**8+ GB RAM**，**4+ CPU 核心**。

## 文档

- [RAGFlow 文档](https://ragflow.io/docs)
- [GitHub](https://github.com/infiniflow/ragflow)
