# MongoDB 单节点副本集

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个单节点 MongoDB 副本集，特别适合开发和测试环境。

## 前提条件

1. 为副本集生成一个密钥文件：

   ```bash
   mkdir -p ./secrets
   openssl rand -base64 756 > ./secrets/rs0.key
   ```

   在 Windows 上，您可以使用 Git Bash 或 WSL，或从 [MongoDB 文档](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/) 下载密钥文件。

## 初始化

1. 启动服务：

   ```bash
   docker compose up -d
   ```

   这些服务将通过 `mongo-init` init 容器自动初始化副本集。该容器会：
   - 等待 MongoDB 节点就绪
   - 连接到该节点
   - 初始化单节点副本集
   - 通过容器网络进行通信

2. 验证副本集状态：

   ```bash
   docker exec -it mongodb-replicaset-single-mongo1-1 mongosh -u root -p password --authenticationDatabase admin --eval "rs.status()"
   ```

## 服务

- `mongo1`: 副本集的唯一成员。

## 配置

- `TZ`: 容器的时区，默认为 `UTC`。
- `MONGO_VERSION`: MongoDB 镜像的版本，默认为 `8.3.11`。
- `MONGO_INITDB_ROOT_USERNAME`: 数据库的 root 用户名，默认为 `root`。
- `MONGO_INITDB_ROOT_PASSWORD`: 数据库的 root 密码，默认为 `password`。
- `MONGO_INITDB_DATABASE`: 要创建的初始数据库，默认为 `admin`。
- `MONGO_REPLICA_SET_NAME`: 副本集的名称，默认为 `rs0`。
- `MONGO_PORT_OVERRIDE_1`: MongoDB 节点的主机端口，默认为 `27017`。
- `MONGO_HOST`: MongoDB 节点的主机名，默认为 `mongo1`。

## 卷

- `mongo_data`: 用于 MongoDB 数据持久化的命名卷。
- `secrets/rs0.key`: 副本集成员身份验证的密钥文件。

## 安全性

副本集密钥文件以只读方式挂载，并在容器内复制到 `/tmp`，权限为 400。这种方法确保跨平台兼容性（Windows/Linux/macOS），同时保持安全要求。密钥文件不会在主机系统上被修改。

## 升级

更改镜像标签前，请备份数据库并测试升级路径。MongoDB 升级应遵循受支持的相邻次要版本步骤。对于此单成员副本集，请安排停机时间，并在升级前后确认成员健康。二进制版本升级后，请检查 Feature Compatibility Version（FCV），并仅在符合目标版本要求时设置。更改镜像标签不代表数据会自动迁移，也不保证迁移始终安全。

## 使用单节点副本集

您可以使用任何 MongoDB 客户端连接到 MongoDB 副本集：

```bash
mongosh "mongodb://root:password@localhost:27017/admin?authSource=admin&replicaSet=rs0"
```

或使用 Python 的 PyMongo：

```python
from pymongo import MongoClient

client = MongoClient("mongodb://root:password@localhost:27017/admin?authSource=admin&replicaSet=rs0")
db = client.admin
print(db.command("ping"))
```
