# Gitea

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个 Gitea 服务。

## 服务

- `server`: Gitea 应用服务。
- `db`: PostgreSQL 数据库服务。

## 初始设置

在初始页面需要填入数据库信息：

- 数据库类型：`PostgreSQL`
- 主机：`db:5432`
- 用户名：`gitea`
- 密码：`gitea`（默认值）
- 数据库名称：`gitea`

第一个注册的用户将拥有管理员权限。

## 配置

可以通过 `./config/app.ini` 文件配置 Gitea 的基本信息。例如，通过以下配置可以关闭注册功能：

```ini
[service]
DISABLE_REGISTRATION = true
```

### 环境变量

- `POSTGRES_USER`: PostgreSQL 数据库的用户名，默认为 `gitea`。
- `POSTGRES_PASSWORD`: PostgreSQL 数据库的密码，默认为 `gitea`。
- `POSTGRES_DB`: PostgreSQL 数据库的名称，默认为 `gitea`。

## 卷

- `data`: 用于存储 Gitea 数据的卷。
- `config`: 用于存储 Gitea 配置的卷。
- `postgres`: 用于存储 PostgreSQL 数据的卷。
