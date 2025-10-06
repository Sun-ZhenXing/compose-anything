# Harbor

[Harbor](https://goharbor.io/) 是一个开源的容器镜像仓库，通过策略和基于角色的访问控制来保护制品，确保镜像经过扫描且没有漏洞，并将镜像签名为可信任的。

## 功能特性

- 安全与漏洞分析：扫描镜像漏洞
- 内容信任：签名和验证镜像
- 基于策略的复制：跨注册表复制镜像
- 基于角色的访问控制：细粒度的访问控制
- Webhook 通知：事件发生时通知外部服务
- 多租户：支持多个项目

## 快速开始

启动 Harbor：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `HARBOR_VERSION`: Harbor 版本（默认：`v2.12.0`）
- `HARBOR_HTTP_PORT_OVERRIDE`: HTTP 端口（默认：`80`）
- `HARBOR_HTTPS_PORT_OVERRIDE`: HTTPS 端口（默认：`443`）
- `HARBOR_ADMIN_PASSWORD`: 管理员密码（默认：`Harbor12345`）
- `HARBOR_DB_PASSWORD`: 数据库密码（默认：`password`）
- `HARBOR_CORE_SECRET`: 核心服务密钥
- `HARBOR_JOBSERVICE_SECRET`: 作业服务密钥
- `HARBOR_REGISTRY_SECRET`: 注册表 HTTP 密钥
- `HARBOR_RELOAD_KEY`: 配置重载密钥

## 访问

- Web UI: <http://localhost>
- Docker 镜像仓库: <http://localhost>

默认凭据：

- 用户名：`admin`
- 密码：`Harbor12345`（或 `HARBOR_ADMIN_PASSWORD` 的值）

## 使用方法

### 登录到 Harbor

```bash
docker login localhost
```

### 推送镜像

```bash
docker tag myimage:latest localhost/myproject/myimage:latest
docker push localhost/myproject/myimage:latest
```

### 拉取镜像

```bash
docker pull localhost/myproject/myimage:latest
```

## 重要提示

⚠️ **安全警告**：

- 首次登录后立即更改默认管理员密码
- 为所有密钥环境变量设置安全的值
- 在生产环境中使用 HTTPS

## 组件

- **harbor-core**: 核心 API 服务器
- **harbor-portal**: Web UI
- **harbor-jobservice**: 后台作业服务
- **harbor-registry**: Docker 镜像仓库
- **harbor-db**: PostgreSQL 数据库
- **harbor-redis**: Redis 缓存
- **harbor-proxy**: Nginx 反向代理

## 资源配置

- Core: 1 CPU，2G 内存
- JobService: 0.5 CPU，512M 内存
- Registry: 0.5 CPU，512M 内存
- Database: 1 CPU，1G 内存
- Redis: 0.5 CPU，256M 内存
