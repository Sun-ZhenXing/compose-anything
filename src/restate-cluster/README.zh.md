# Restate 多节点集群

用于生产工作负载的高可用 3 节点 Restate 集群。此配置提供容错和自动故障转移功能。

## 特性

- **高可用性**：3 节点集群可以容忍 1 个节点故障
- **数据复制**：可配置的复制因子（默认：3 个节点中的 2 个）
- **自动快照**：定期快照存储在 MinIO（S3 兼容）中
- **负载分配**：用于负载均衡的多个入口端点
- **元数据仲裁**：用于一致性的复制元数据集群

## 快速开始

1. 复制环境变量文件：

   ```bash
   cp .env.example .env
   ```

2. 启动集群：

   ```bash
   docker compose up -d
   ```

3. 验证集群健康状态：

   ```bash
   # 检查节点 1
   curl http://localhost:9070/health
   
   # 检查节点 2
   curl http://localhost:29070/health
   
   # 检查节点 3
   curl http://localhost:39070/health
   ```

## 架构

集群由以下部分组成：

- **3 个 Restate 节点**：具有复制状态的分布式工作流引擎
- **MinIO**：用于分区快照的 S3 兼容存储
- **Replicated Bifrost Provider**：跨节点的日志复制
- **元数据集群**：所有节点上的分布式元数据服务器

## 服务端点

### 节点 1（主节点）

- Ingress API：`http://localhost:8080`
- Admin API：`http://localhost:9070`
- 节点通信：端口 5122

### 节点 2

- Ingress API：`http://localhost:28080`
- Admin API：`http://localhost:29070`
- 节点通信：端口 25122

### 节点 3

- Ingress API：`http://localhost:38080`
- Admin API：`http://localhost:39070`
- 节点通信：端口 35122

### MinIO

- API：`http://localhost:9000`
- 控制台：`http://localhost:9001`（管理 UI）
  - 用户名：`minioadmin`
  - 密码：`minioadmin`

## 环境变量

### 集群配置

| 变量                          | 默认值            | 说明                 |
| ----------------------------- | ----------------- | -------------------- |
| `RESTATE_VERSION`             | `1.5.3`           | Restate 服务器版本   |
| `RESTATE_CLUSTER_NAME`        | `restate-cluster` | 集群名称             |
| `RESTATE_DEFAULT_REPLICATION` | `2`               | 写入所需的最小副本数 |

### 端口配置

每个节点有三个端口：

- `NODEx_INGRESS_PORT_OVERRIDE`：Ingress API 端口
- `NODEx_ADMIN_PORT_OVERRIDE`：Admin API 端口
- `NODEx_NODE_PORT_OVERRIDE`：节点间通信端口

### 快照配置

| 变量                                                       | 默认值                   | 说明             |
| ---------------------------------------------------------- | ------------------------ | ---------------- |
| `RESTATE_WORKER__SNAPSHOTS__DESTINATION`                   | `s3://restate/snapshots` | S3 存储桶路径    |
| `RESTATE_WORKER__SNAPSHOTS__SNAPSHOT_INTERVAL_NUM_RECORDS` | `1000`                   | 每个快照的记录数 |
| `RESTATE_WORKER__SNAPSHOTS__AWS_ENDPOINT_URL`              | `http://minio:9000`      | S3 端点          |

### MinIO 配置

| 变量                          | 默认值       | 说明               |
| ----------------------------- | ------------ | ------------------ |
| `MINIO_VERSION`               | `latest`     | MinIO 版本         |
| `MINIO_ROOT_USER`             | `minioadmin` | MinIO 管理员用户名 |
| `MINIO_ROOT_PASSWORD`         | `minioadmin` | MinIO 管理员密码   |
| `MINIO_API_PORT_OVERRIDE`     | `9000`       | MinIO API 端口     |
| `MINIO_CONSOLE_PORT_OVERRIDE` | `9001`       | MinIO 控制台端口   |

## 使用示例

### 部署服务（到任何节点）

```bash
# 部署到节点 1
curl -X POST http://localhost:9070/deployments \
  -H 'Content-Type: application/json' \
  -d '{"uri": "http://my-service:9080"}'
```

### 使用负载均衡调用服务

使用负载均衡器或 DNS 轮询跨入口端点：

```bash
# 节点 1
curl -X POST http://localhost:8080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'

# 节点 2
curl -X POST http://localhost:28080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'
```

### 检查集群状态

```bash
# 从任何管理 API
curl http://localhost:9070/cluster
```

## 容错能力

集群配置为：

- **复制因子**：2（数据写入 3 个节点中的 2 个）
- **仲裁**：元数据操作需要多数（2/3 节点）
- **容错能力**：可以在不停机的情况下容忍 1 个节点故障

### 测试故障转移

停止一个节点：

```bash
docker compose stop restate-2
```

集群继续运行。服务在节点 1 和 3 上仍然可用。

## 快照和备份

分区快照每 1000 条记录自动保存到 MinIO。这使得：

- 故障后快速恢复
- 备份和恢复功能
- 减少节点重启时的重放时间

### 查看快照

在 `http://localhost:9001` 访问 MinIO 控制台：

1. 使用 `minioadmin` / `minioadmin` 登录
2. 导航到 `restate` 存储桶
3. 浏览 `snapshots/` 目录

### 备份策略

要备份集群数据：

1. 停止集群：

   ```bash
   docker compose down
   ```

2. 备份卷：

   ```bash
   docker run --rm -v restate-cluster_restate_data:/data -v $(pwd)/backup:/backup alpine tar czf /backup/restate-data.tar.gz -C /data .
   docker run --rm -v restate-cluster_minio_data:/data -v $(pwd)/backup:/backup alpine tar czf /backup/minio-data.tar.gz -C /data .
   ```

## 资源限制

### 每个 Restate 节点

- CPU：0.5-2.0 核心
- 内存：512MB-2GB

### MinIO 实例

- CPU：0.25-1.0 核心
- 内存：128MB-512MB

根据 `docker-compose.yaml` 中的工作负载进行调整。

## 扩展

要添加更多节点：

1. 在 `docker-compose.yaml` 中添加新服务
2. 设置唯一的 `RESTATE_NODE_NAME` 和 `RESTATE_FORCE_NODE_ID`
3. 将节点地址添加到 `RESTATE_METADATA_CLIENT__ADDRESSES`
4. 暴露唯一端口
5. 设置 `RESTATE_AUTO_PROVISION=false`

## 生产注意事项

- **存储**：使用持久存储卷（EBS、持久磁盘）
- **网络**：确保节点之间的低延迟（<10ms）
- **监控**：在端口 9070 上设置 Prometheus 抓取
- **安全**：在生产环境中更改 MinIO 凭据
- **复制**：根据集群大小调整 `RESTATE_DEFAULT_REPLICATION`
- **快照**：考虑使用外部 S3 进行快照存储

## 监控

每个节点都公开指标：

```bash
curl http://localhost:9070/metrics   # 节点 1
curl http://localhost:29070/metrics  # 节点 2
curl http://localhost:39070/metrics  # 节点 3
```

## 故障排除

### 节点无法启动

检查日志：

```bash
docker compose logs restate-1
```

确保所有节点可以在端口 5122 上相互访问。

### 防止脑裂

集群使用 raft 共识和多数仲裁。如果节点被分区，只有具有多数（2+ 节点）的分区保持活动状态。

### 数据恢复

如果数据损坏：

1. 停止集群
2. 从卷备份恢复
3. 重启集群

## 文档

- [官方文档](https://docs.restate.dev/)
- [集群部署指南](https://docs.restate.dev/server/clusters)
- [快照文档](https://docs.restate.dev/server/snapshots)
- [配置参考](https://docs.restate.dev/references/server-config)

## 许可证

此配置在项目许可证下提供。Restate 采用 [Business Source License 1.1](https://github.com/restatedev/restate/blob/main/LICENSE) 许可。

## 注意事项

- 对于单节点部署，请参见 [restate](../restate/)
- MinIO 用于演示目的；在生产环境中使用 AWS S3/兼容存储
- 集群在首次启动时自动配置
- 节点 ID 被固定以确保重启时的一致标识
