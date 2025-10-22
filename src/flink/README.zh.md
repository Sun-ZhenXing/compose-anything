# Apache Flink

Apache Flink 是一个框架和分布式处理引擎，用于对无界和有界数据流进行有状态计算。

## 使用方法

```bash
docker compose up -d
```

## 组件说明

此配置包含：

- **JobManager**：协调 Flink 作业并管理资源
- **TaskManager**：执行任务并管理数据流

## 配置说明

`FLINK_PROPERTIES` 中的关键环境变量：

- `jobmanager.rpc.address`：JobManager RPC 地址
- `jobmanager.memory.process.size`：JobManager 内存（默认：1600m）
- `taskmanager.memory.process.size`：TaskManager 内存（默认：1600m）
- `taskmanager.numberOfTaskSlots`：每个 TaskManager 的任务槽数量（默认：2）

## 端口说明

- `6123`：JobManager RPC 端口
- `8081`：Flink Web UI

## 访问方式

### Web UI

访问 Flink Dashboard：<http://localhost:8081>

### 提交作业

提交 Flink 作业：

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/examples/streaming/WordCount.jar
```

提交自定义作业：

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/jobs/my-job.jar
```

### 作业管理

```bash
# 列出运行中的作业
docker compose exec jobmanager ./bin/flink list

# 取消作业
docker compose exec jobmanager ./bin/flink cancel <job-id>

# 显示作业详情
docker compose exec jobmanager ./bin/flink info /path/to/job.jar
```

## 示例：WordCount

运行内置的 WordCount 示例：

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/examples/streaming/WordCount.jar
```

## 扩展 TaskManager

要扩展 TaskManager 以获得更多处理能力：

```bash
docker compose up -d --scale taskmanager=3
```

## 自定义作业

通过取消注释 `docker-compose.yaml` 中的卷来挂载自定义 Flink 作业：

```yaml
volumes:
  - ./jobs:/opt/flink/jobs
```

然后将 JAR 文件放在 `./jobs` 目录中。

## 注意事项

- 这是一个独立集群配置，适合开发环境
- 生产环境建议在 Kubernetes 或 YARN 上使用 Flink
- 根据工作负载需求调整内存设置
- 任务槽决定并行度，更多槽允许更多并行任务
- 数据持久化在命名卷 `flink_data` 中

## 参考资料

- [Apache Flink 官方文档](https://flink.apache.org/zh/docs/stable/)
- [Flink Docker 设置](https://nightlies.apache.org/flink/flink-docs-stable/docs/deployment/resource-providers/standalone/docker/)
- [Flink Docker Hub](https://hub.docker.com/_/flink)
