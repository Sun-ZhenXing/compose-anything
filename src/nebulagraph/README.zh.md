# NebulaGraph

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 NebulaGraph，一个分布式、快速的开源图数据库。

## 服务

- `metad`：用于集群管理的元数据服务
- `storaged`：用于数据持久化的存储服务
- `graphd`：用于客户端连接的查询服务

## 环境变量

| 变量名                        | 说明             | 默认值   |
| ----------------------------- | ---------------- | -------- |
| `NEBULA_VERSION`              | NebulaGraph 版本 | `v3.8.0` |
| `NEBULA_GRAPHD_PORT_OVERRIDE` | GraphD 端口覆盖  | `9669`   |

## 卷

- `nebula_meta_data`：元数据服务数据
- `nebula_storage_data`：存储服务数据
- `nebula_*_logs`：各服务的日志文件

## 使用方法

### 启动 NebulaGraph

```bash
docker compose up -d
```

### 连接到 NebulaGraph

```bash
# 使用控制台
docker run --rm -it --network host vesoft/nebula-console:v3.8.0 -addr 127.0.0.1 -port 9669 -u root -p nebula
```

## 访问

- GraphD：<tcp://localhost:9669>

## 注意事项

- 默认凭据：root/nebula
- 启动后等待 20-30 秒以使服务就绪
- 适合开发和测试使用

## 许可证

NebulaGraph 采用 Apache License 2.0 许可。
