# FalkorDB

[FalkorDB](https://falkordb.com/) 是一个低延迟的属性图数据库，利用稀疏矩阵和线性代数实现高性能图查询。它是 RedisGraph 的社区驱动分支，针对大规模知识图谱和 AI 驱动的应用进行了优化。

## 快速开始

1. 将 `.env.example` 复制为 `.env` 并根据需要调整配置。
2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 通过 `http://localhost:3000` 访问 FalkorDB Browser 界面。
4. 使用 `redis-cli` 或任何兼容 Redis 的客户端连接到 `6379` 端口。

## 环境变量

| 变量名                           | 描述                 | 默认值     |
| -------------------------------- | -------------------- | ---------- |
| `FALKORDB_VERSION`               | FalkorDB 镜像版本    | `v4.14.11` |
| `FALKORDB_PORT_OVERRIDE`         | Redis 协议的主机端口 | `6379`     |
| `FALKORDB_BROWSER_PORT_OVERRIDE` | 浏览器界面的主机端口 | `3000`     |
| `FALKORDB_CPU_LIMIT`             | 最大 CPU 使用率      | `1.00`     |
| `FALKORDB_MEMORY_LIMIT`          | 最大内存限制         | `2G`       |

## 相关资源

- [官方文档](https://docs.falkordb.com/)
- [GitHub 仓库](https://github.com/FalkorDB/FalkorDB)
- [Docker Hub](https://hub.docker.com/r/falkordb/falkordb)
