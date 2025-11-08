# Nacos

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Nacos，一个动态服务发现、配置管理和服务管理平台。

## 服务

- `nacos`：独立模式的 Nacos 服务器

## 快速开始

```bash
docker compose up -d
```

## 环境变量

| 变量名                       | 说明                               | 默认值                                                                  |
| ---------------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| `GLOBAL_REGISTRY`            | 全局镜像仓库前缀                   | `""`                                                                    |
| `NACOS_VERSION`              | Nacos 镜像版本                     | `v3.1.0-slim`                                                           |
| `NACOS_HTTP_PORT_OVERRIDE`   | HTTP 主机端口（映射到端口 8848）   | `8848`                                                                  |
| `NACOS_GRPC_PORT_OVERRIDE`   | gRPC 主机端口（映射到端口 9848）   | `9848`                                                                  |
| `NACOS_GRPC_PORT2_OVERRIDE`  | gRPC 2 主机端口（映射到端口 9849） | `9849`                                                                  |
| `NACOS_MODE`                 | Nacos 模式（standalone/cluster）   | `standalone`                                                            |
| `NACOS_AUTH_ENABLE`          | 启用身份验证                       | `true`                                                                  |
| `NACOS_AUTH_TOKEN`           | 身份验证令牌（32+ 字符）           | `SecretKey012345678901234567890123456789012345678901234567890123456789` |
| `NACOS_AUTH_IDENTITY_KEY`    | 身份验证的标识键                   | `serverIdentity`                                                        |
| `NACOS_AUTH_IDENTITY_VALUE`  | 身份验证的标识值                   | `security`                                                              |
| `SPRING_DATASOURCE_PLATFORM` | 数据库平台（留空使用嵌入式数据库） | `""`                                                                    |
| `JVM_XMS`                    | JVM 初始堆大小                     | `512m`                                                                  |
| `JVM_XMX`                    | JVM 最大堆大小                     | `512m`                                                                  |
| `JVM_XMN`                    | JVM 年轻代堆大小                   | `256m`                                                                  |
| `TZ`                         | 时区                               | `UTC`                                                                   |

请根据实际需求修改 `.env` 文件。

## 卷

- `nacos_logs`：Nacos 日志目录

## 端口

- `8848`：Nacos HTTP API 和控制台
- `9848`：Nacos gRPC 端口（用于客户端-服务器通信）
- `9849`：Nacos gRPC 端口 2（用于集群模式下的服务器-服务器通信）

## 访问点

- Nacos 控制台：<http://localhost:8848/nacos>
- 默认凭据：`nacos` / `nacos`

## 基本使用

### 注册服务

```bash
curl -X POST 'http://localhost:8848/nacos/v1/ns/instance' \
  -d 'serviceName=example-service&ip=127.0.0.1&port=8080'
```

### 发现服务

```bash
curl 'http://localhost:8848/nacos/v1/ns/instance/list?serviceName=example-service'
```

### 发布配置

```bash
curl -X POST 'http://localhost:8848/nacos/v1/cs/configs' \
  -d 'dataId=example.properties&group=DEFAULT_GROUP&content=key=value'
```

### 获取配置

```bash
curl 'http://localhost:8848/nacos/v1/cs/configs?dataId=example.properties&group=DEFAULT_GROUP'
```

## 外部数据库（可选）

生产环境中使用外部 MySQL 数据库时，请设置以下环境变量：

```env
SPRING_DATASOURCE_PLATFORM=mysql
MYSQL_SERVICE_HOST=mysql-host
MYSQL_SERVICE_PORT=3306
MYSQL_SERVICE_DB_NAME=nacos
MYSQL_SERVICE_USER=nacos
MYSQL_SERVICE_PASSWORD=nacos
```

## 安全提示

- 首次登录后立即更改默认凭据
- 使用强身份验证令牌（32+ 字符）
- 生产环境中使用外部 MySQL 数据库而非嵌入式 Derby
- 生产环境中启用 HTTPS
- 定期更新 Nacos 版本以获取安全补丁

## 许可证

Nacos 采用 Apache License 2.0 许可。详情请参见 [Nacos GitHub](https://github.com/alibaba/nacos)。
