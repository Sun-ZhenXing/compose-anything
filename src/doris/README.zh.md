# Doris

Apache Doris 是一个现代化的 OLAP 数据库，为快速分析和实时商业智能而设计。它提供兼容标准 SQL 语义的 SQL 接口，并支持批量和实时数据处理。

## 快速开始

```bash
docker compose up -d
```

## 端口

| 服务 | 端口 | 用途               |
| ---- | ---- | ------------------ |
| FE   | 9030 | 查询端口           |
| FE   | 8030 | Web UI 和 HTTP API |
| BE   | 8040 | 后端 HTTP 端口     |

## 默认凭证

- Web UI：<http://localhost:8030>
- 用户名：`admin`
- 密码：`admin`（默认值，应该更改）

## 环境变量

关键环境变量：

- `DORIS_VERSION`：Docker 镜像版本（默认值：3.0.0）
- `DORIS_FE_CPU_LIMIT`：FE CPU 限制（默认值：1.00）
- `DORIS_FE_MEMORY_LIMIT`：FE 内存限制（默认值：2G）
- `DORIS_BE_CPU_LIMIT`：BE CPU 限制（默认值：2.00）
- `DORIS_BE_MEMORY_LIMIT`：BE 内存限制（默认值：4G）

请查看 `.env.example` 获取所有可用选项。

## 架构

该部署包括：

- **Frontend（FE）**：处理查询规划、元数据管理和用户连接
- **Backend（BE）**：执行查询并管理数据存储

## 文档

- [Apache Doris 官方文档](https://doris.apache.org/)
- [快速入门指南](https://doris.apache.org/docs/get-starting/)
- [SQL 参考](https://doris.apache.org/docs/sql-manual/)

## 许可证

Apache License 2.0
