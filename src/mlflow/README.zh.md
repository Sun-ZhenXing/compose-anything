# MLflow

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署带有 PostgreSQL 后端和 MinIO 工件存储的 MLflow。

## 服务

- `mlflow`: MLflow 跟踪服务器。
- `postgres`: 用于 MLflow 元数据的 PostgreSQL 数据库。
- `minio`: 用于工件存储的 MinIO 服务器（S3 兼容）。
- `minio-init`: 创建 MLflow 存储桶的初始化服务。

## 环境变量

| 变量名                      | 说明                  | 默认值                         |
| --------------------------- | --------------------- | ------------------------------ |
| MLFLOW_VERSION              | MLflow 镜像版本       | `v2.20.2`                      |
| POSTGRES_VERSION            | PostgreSQL 镜像版本   | `17.6-alpine`                  |
| POSTGRES_USER               | PostgreSQL 用户名     | `mlflow`                       |
| POSTGRES_PASSWORD           | PostgreSQL 密码       | `mlflow`                       |
| POSTGRES_DB                 | PostgreSQL 数据库名称 | `mlflow`                       |
| MINIO_VERSION               | MinIO 镜像版本        | `RELEASE.2025-01-07T16-13-09Z` |
| MINIO_MC_VERSION            | MinIO 客户端版本      | `RELEASE.2025-01-07T17-25-52Z` |
| MINIO_ROOT_USER             | MinIO 根用户名        | `minio`                        |
| MINIO_ROOT_PASSWORD         | MinIO 根密码          | `minio123`                     |
| MINIO_BUCKET                | 工件的 MinIO 存储桶   | `mlflow`                       |
| MLFLOW_PORT_OVERRIDE        | MLflow 服务器端口     | `5000`                         |
| MINIO_PORT_OVERRIDE         | MinIO API 端口        | `9000`                         |
| MINIO_CONSOLE_PORT_OVERRIDE | MinIO 控制台端口      | `9001`                         |

请根据实际需求修改 `.env` 文件。

## 卷

- `postgres_data`: PostgreSQL 数据存储。
- `minio_data`: 工件的 MinIO 数据存储。

## 使用方法

### 访问 MLflow UI

启动服务后，在以下地址访问 MLflow UI：

```text
http://localhost:5000
```

### 配置 MLflow 客户端

在你的 Python 脚本或笔记本中：

```python
import mlflow

# 设置跟踪 URI
mlflow.set_tracking_uri("http://localhost:5000")

# 你的 MLflow 代码
with mlflow.start_run():
    mlflow.log_param("param1", 5)
    mlflow.log_metric("metric1", 0.89)
```

### MinIO 控制台

在以下地址访问 MinIO 控制台：

```text
http://localhost:9001
```

使用 `MINIO_ROOT_USER` 和 `MINIO_ROOT_PASSWORD` 中指定的凭据登录。

## 功能

- **实验跟踪**: 使用参数、指标和工件跟踪 ML 实验
- **模型注册表**: 版本化和管理 ML 模型
- **项目**: 以可重用格式打包 ML 代码
- **模型**: 将 ML 模型部署到各种平台
- **持久存储**: PostgreSQL 用于元数据，MinIO 用于工件

## 注意事项

- `minio-init` 服务运行一次以创建存储桶，然后停止。
- 对于生产环境，请更改所有默认密码。
- 考虑使用外部 PostgreSQL 和 S3 兼容存储用于生产环境。
- 该设置使用命名卷进行数据持久化。

## 许可证

MLflow 使用 Apache License 2.0 授权。
