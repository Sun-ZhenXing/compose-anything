# MongoDB 副本集

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个包含三个成员的 MongoDB 副本集。

## 前提条件

1. 为副本集生成一个密钥文件：

   ```bash
   openssl rand -base64 756 > ./secrets/rs0.key
   ```

## 初始化

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 连接到主节点：

   ```bash
   docker exec -it mongodb-replicaset-mongo1-1 mongosh
   ```

3. 初始化副本集。**请记得将 host IP 替换为你的实际主机 IP。**

   ```js
   config = {
     _id: "rs0",
     members: [
       {_id: 0, host: "192.168.31.38:27017"},
       {_id: 1, host: "192.168.31.38:27018"},
       {_id: 2, host: "192.168.31.38:27019"},
     ]
   }
   rs.initiate(config)
   ```

## 服务

- `mongo1`: 副本集的第一个成员。
- `mongo2`: 副本集的第二个成员。
- `mongo3`: 副本集的第三个成员。

## 配置

- `MONGO_VERSION`: MongoDB 镜像的版本，默认为 `8.0.13`。
- `MONGO_INITDB_ROOT_USERNAME`: 数据库的 root 用户名，默认为 `root`。
- `MONGO_INITDB_ROOT_PASSWORD`: 数据库的 root 密码，默认为 `password`。
- `MONGO_INITDB_DATABASE`: 要创建的初始数据库，默认为 `admin`。
- `MONGO_REPLICA_SET_NAME`: 副本集的名称，默认为 `rs0`。
- `MONGO_PORT_OVERRIDE_1`: 第一个成员的主机端口，默认为 `27017`。
- `MONGO_PORT_OVERRIDE_2`: 第二个成员的主机端口，默认为 `27018`。
- `MONGO_PORT_OVERRIDE_3`: 第三个成员的主机端口，默认为 `27019`。

## 卷

- `secrets/rs0.key`: 用于副本集成员之间认证的密钥文件。
