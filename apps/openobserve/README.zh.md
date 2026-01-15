# OpenObserve

[OpenObserve](https://openobserve.ai/) 是一个专为日志、指标、追踪、分析等构建的云原生可观测平台。与 Elasticsearch、Splunk 和 Datadog 等传统可观测解决方案相比，它提供了 10 倍更简单的部署、140 倍更低的存储成本和高性能。

## 功能特性

- **统一可观测性**：日志、指标、追踪和前端监控（RUM）集成在单一平台
- **成本效益**：通过 Parquet 列式存储和 S3 原生架构，存储成本比 Elasticsearch 低 140 倍
- **高性能**：查询性能优于 Elasticsearch，同时仅使用 1/4 的硬件资源
- **单一二进制**：从可扩展至 TB 级的单一二进制开始，或部署高可用模式以处理 PB 级工作负载
- **易于使用**：无需复杂调优，直观的 UI，支持 SQL 和 PromQL
- **OpenTelemetry 原生**：内置 OTLP 日志、指标和追踪采集
- **灵活存储**：支持本地磁盘、S3、MinIO、GCS 或 Azure Blob 存储
- **生产就绪**：全球数千个部署，最大部署每天处理 2 PB 数据

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 并配置：
   - `ZO_ROOT_USER_EMAIL`：管理员邮箱（修改默认值）
   - `ZO_ROOT_USER_PASSWORD`：管理员密码（修改默认值，最少 8 个字符且包含特殊字符）
   - `OPENOBSERVE_PORT_OVERRIDE`：Web UI 端口（默认：5080）

3. 启动 OpenObserve：

   ```bash
   docker compose up -d
   ```

4. 访问 Web UI：`http://localhost:5080`

5. 使用配置的凭据登录

## 配置说明

### 基础配置

| 环境变量                    | 说明                 | 默认值              |
| --------------------------- | -------------------- | ------------------- |
| `OPENOBSERVE_VERSION`       | OpenObserve 镜像版本 | `v0.50.0`           |
| `OPENOBSERVE_PORT_OVERRIDE` | Web UI 端口          | `5080`              |
| `ZO_ROOT_USER_EMAIL`        | 根用户邮箱           | `admin@example.com` |
| `ZO_ROOT_USER_PASSWORD`     | 根用户密码           | `Complexpass#123`   |
| `ZO_DATA_DIR`               | 容器内数据目录       | `/data`             |

### S3 对象存储（可选）

对于生产部署，配置兼容 S3 的对象存储：

| 环境变量            | 说明          |
| ------------------- | ------------- |
| `ZO_S3_BUCKET_NAME` | S3 存储桶名称 |
| `ZO_S3_REGION_NAME` | S3 区域       |
| `ZO_S3_ACCESS_KEY`  | S3 访问密钥   |
| `ZO_S3_SECRET_KEY`  | S3 密钥       |

配置 S3 后，OpenObserve 将使用它进行数据存储，而不是本地卷。

### 资源限制

根据工作负载调整 CPU 和内存限制：

| 环境变量                         | 说明            | 默认值 |
| -------------------------------- | --------------- | ------ |
| `OPENOBSERVE_CPU_LIMIT`          | 最大 CPU 核心数 | `2.0`  |
| `OPENOBSERVE_CPU_RESERVATION`    | 预留 CPU 核心数 | `0.5`  |
| `OPENOBSERVE_MEMORY_LIMIT`       | 最大内存        | `2G`   |
| `OPENOBSERVE_MEMORY_RESERVATION` | 预留内存        | `512M` |

## 数据采集

OpenObserve 支持多种采集方式：

### OpenTelemetry (OTLP)

发送 OTLP 数据到 `http://localhost:5080/api/default/` 并进行身份验证。

### 通过 HTTP 采集日志

```bash
curl -u admin@example.com:Complexpass#123 \
  -H "Content-Type: application/json" \
  http://localhost:5080/api/default/logs/_json \
  -d '[{"message": "Hello OpenObserve", "level": "info"}]'
```

### Prometheus 远程写入

配置 Prometheus 使用 OpenObserve 作为远程写入目标。

更多采集方法请参见[官方文档](https://openobserve.ai/docs/ingestion/)。

## 架构

OpenObserve 通过以下方式实现其性能和成本效率：

- **Parquet 列式存储**：高效压缩和查询性能
- **S3 原生设计**：利用廉价对象存储与智能缓存
- **Rust 构建**：内存安全、高性能实现
- **智能分区和索引**：大多数查询可将搜索空间减少高达 99%
- **无状态架构**：支持快速扩展和灾难恢复

## 数据卷

- `openobserve_data`：使用本地磁盘存储时存储所有数据（配置 S3 时不使用）

## 安全注意事项

1. **修改默认凭据**：在生产环境中务必修改 `ZO_ROOT_USER_EMAIL` 和 `ZO_ROOT_USER_PASSWORD`
2. **密码要求**：使用强密码，至少 8 个字符且包含特殊字符
3. **网络安全**：生产部署时考虑使用带 TLS 的反向代理
4. **S3 凭据**：安全存储 S3 凭据，在可能的情况下考虑使用 IAM 角色
5. **数据不可变性**：所有采集的数据在设计上都是不可变的，以满足审计合规要求

## 升级

升级到新版本：

1. 在 `.env` 中更新 `OPENOBSERVE_VERSION`
2. 拉取新镜像并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

OpenObserve 会自动处理模式迁移，无需手动步骤。

## 企业版功能

企业版包含：

- 单点登录（SSO）：OIDC、OAuth、SAML、LDAP/AD
- 高级 RBAC：基于角色的访问控制与自定义角色
- 审计跟踪：不可变审计日志
- 联合搜索：跨多个集群查询
- 敏感数据脱敏：自动 PII 脱敏
- 带 SLA 保证的优先支持

详情请参见[价格页面](https://openobserve.ai/downloads/)。

## 许可证

- 开源版：AGPL-3.0
- 企业版：商业许可证

## 相关链接

- [官方网站](https://openobserve.ai/)
- [文档](https://openobserve.ai/docs/)
- [GitHub 仓库](https://github.com/openobserve/openobserve)
- [Slack 社区](https://short.openobserve.ai/community)
- [客户案例](https://openobserve.ai/customer-stories/)

## 支持

- 通过 [Slack](https://short.openobserve.ai/community) 获得社区支持
- GitHub [Issues](https://github.com/openobserve/openobserve/issues)
- GitHub [Discussions](https://github.com/openobserve/openobserve/discussions)
- 商业许可证提供企业支持
