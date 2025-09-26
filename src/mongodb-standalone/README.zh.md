# MongoDB 单机版

[English](./README.md) | [中文](./README.zh.md)

MongoDB 是一个为应用程序开发和扩展的简易性而设计的文档数据库。

## 初始化

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 连接到 MongoDB：`mongodb://root:password@localhost:27017/admin`

## 服务

- `mongo`: MongoDB 服务。

## 配置

- **用户名**: `root`
- **密码**: `password`
- **数据库**: `admin`
- **端口**: `27017`

| 变量                         | 描述         | 默认值     |
| ---------------------------- | ------------ | ---------- |
| `MONGO_VERSION`              | MongoDB 版本 | `8.0.13`   |
| `MONGO_INITDB_ROOT_USERNAME` | 根用户名     | `root`     |
| `MONGO_INITDB_ROOT_PASSWORD` | 根密码       | `password` |
| `MONGO_INITDB_DATABASE`      | 初始数据库   | `admin`    |
| `MONGO_PORT_OVERRIDE`        | 端口覆盖     | `27017`    |

## 卷

- `mongo_data`: 用于存储 MongoDB 数据的卷。

```bash
# 使用 mongo shell
mongo mongodb://root:password@localhost:27017/admin

# 使用 mongosh
mongosh "mongodb://root:password@localhost:27017/admin"
```

## 安全说明

- 在生产环境使用前更改默认密码
- 考虑使用 MongoDB 认证和授权功能
- 根据需要限制网络访问

## 许可证

MongoDB 在服务器端公共许可证 (SSPL) 下可用。
