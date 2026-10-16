# ZenML

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 ZenML——一个开源 MLOps 流水线平台，后端为 MySQL，并包含可选的 Adminer、可观测性（OpenTelemetry/Prometheus）以及 SQLite 开发变体。

## 功能

- **流水线编排**：以代码方式定义、运行和管理 ML 流水线
- **版本管理**：跟踪工件、模型和流水线版本
- **栈管理**：组合编排器、工件存储和其他栈组件
- **Web 控制台**：在浏览器中管理栈、流水线和运行记录
- **持久存储**：MySQL 用于服务器元数据
- **可观测性**：可选的 OpenTelemetry 追踪与 Prometheus 指标

## 快速开始

```bash
cp .env.example .env
docker compose up -d
```

然后在以下地址打开 ZenML 控制台：

```text
http://localhost:8080
```

首次启动时，按照控制台中的首次运行流程创建默认用户，或通过 `ZENML_DEFAULT_USER_NAME` 和 `ZENML_DEFAULT_USER_PASSWORD` 环境变量预先配置凭据（详见 `.env.example`）。

> **注意**：请保持 `zenml` Python 客户端版本与服务器版本一致（本栈固定为 `0.98.0`）。版本不匹配可能导致 API 不兼容问题。

## 默认配置

| 端口 | 用途                                        |
| ---- | ------------------------------------------- |
| 8080 | ZenML 控制台与 REST API（提供 `/health` 端点） |

## 环境变量

| 变量                         | 说明                           | 默认值   |
| ---------------------------- | ------------------------------ | -------- |
| ZENML_VERSION                | ZenML 服务器镜像版本           | `0.98.0` |
| MYSQL_VERSION                | MySQL 镜像版本                 | `8.4`    |
| MYSQL_ROOT_PASSWORD          | MySQL root 密码                  | `zenml-root-pw` |
| MYSQL_DATABASE               | MySQL 数据库名称               | `zenml`  |
| MYSQL_USER                   | MySQL 用户名                   | `zenml`  |
| MYSQL_PASSWORD               | MySQL 密码                     | `zenml`  |
| ZENML_DEFAULT_USER_NAME      | 首次运行的默认用户名             | `default` |
| ZENML_DEFAULT_USER_PASSWORD  | 首次运行的默认用户密码           | `（空）`  |
| ZENML_PORT_OVERRIDE          | ZenML 服务器端口（UI + API）   | `8080`   |
| ADMINER_PORT_OVERRIDE        | Adminer Web UI 端口            | `8081`   |

完整变量列表参见 [.env.example](./.env.example)。

## Profile

| Profile   | 服务                        | 启动命令                                        |
| --------- | --------------------------- | ----------------------------------------------- |
| （默认）  | `zenml`、`mysql`            | `docker compose up -d`                          |
| `dev`     | `zenml-sqlite`、`adminer`   | `docker compose --profile dev up -d`            |
| `metrics` | `otel-collector`、`prometheus` | `docker compose --profile metrics up -d`     |

> **注意**：`zenml-sqlite` 开发变体与默认的 `zenml` 服务共用 8080 端口，请勿同时启用两者。

## 资源要求

- ZenML 服务器在 `docker-compose.yaml` 中定义了合理的 CPU/内存限制；请确保主机至少有 2 GB 空闲内存。
- MySQL 为 InnoDB 缓冲池预留了额外资源，需要相应余量。

## 卷

- `mysql_data`：MySQL 数据存储。
- `zenml_data`：SQLite 开发变体的 ZenML 本地存储。
- `prometheus_data`：Prometheus 时间序列数据（metrics profile）。

## 安全注意事项

- 首次启动前请设置强 `ZENML_DEFAULT_USER_PASSWORD`；默认用户仅创建一次。
- JWT 签名密钥与机密加密密钥由服务器生成并持久化——请备份或通过环境变量显式设置；丢失它们会导致现有会话失效，已加密的机密无法解密。
- 生产环境请更改所有默认的 MySQL 密码。
- ZenML 服务器镜像在支持的情况下以非 root 用户运行。

## 故障排除

- **控制台无法访问**：等待服务器变为健康状态（`docker compose ps`）；首次启动时数据库初始化可能需要一分钟。
- **首次登录失败**：如果未设置 `ZENML_DEFAULT_USER_*`，请按照控制台中的首次运行流程创建凭据。
- **客户端/服务器版本不匹配错误**：确保 `zenml` Python 客户端固定在 `0.98.0`（例如 `pip install "zenml[server]==0.98.0"`）。
- **平台支持**：`zenmldocker/zenml-server` 镜像仅发布 `linux/amd64` 版本；ARM64 主机需要模拟（`docker run --platform linux/amd64`）或改用外部服务器部署。

## 参考

- [ZenML GitHub 仓库](https://github.com/zenml-io/zenml)
- [Docker 部署文档](https://docs.zenml.io/deploying-zenml/deploying-zenml)
- [Docker Hub：zenmldocker/zenml-server](https://hub.docker.com/r/zenmldocker/zenml-server)

## 许可证

ZenML 使用 Apache License 2.0 授权。
