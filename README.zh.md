# Compose Anything

Compose Anything 通过提供一组高质量的 Docker Compose 配置文件，帮助用户快速部署各种服务。这些配置约束了资源使用，可快速迁移到 K8S 等系统，并且易于理解和修改。

## 已经支持的服务

| 服务                                                          | 版本                         |
| ------------------------------------------------------------- | ---------------------------- |
| [Apache APISIX](./src/apisix)                                 | 3.13.0                       |
| [Apache Cassandra](./src/cassandra)                           | 5.0.2                        |
| [Apache Flink](./src/flink)                                   | 1.20.0                       |
| [Apache HBase](./src/hbase)                                   | 2.6                          |
| [Apache HTTP Server](./src/apache)                            | 2.4.62                       |
| [Apache Kafka](./src/kafka)                                   | 7.8.0                        |
| [Apache Pulsar](./src/pulsar)                                 | 4.0.7                        |
| [Apache RocketMQ](./src/rocketmq)                             | 5.3.1                        |
| [Bifrost Gateway](./src/bifrost-gateway)                      | 1.3.48                       |
| [Bolt.diy](./src/bolt-diy)                                    | latest                       |
| [Budibase](./src/budibase)                                    | 3.23.0                       |
| [Bytebot](./src/bytebot)                                      | edge                         |
| [Clash](./src/clash)                                          | 1.18.0                       |
| [ClickHouse](./src/clickhouse)                                | 24.11.1                      |
| [Conductor](./src/conductor)                                  | latest                       |
| [Dify](./src/dify)                                            | 0.18.2                       |
| [DNSMasq](./src/dnsmasq)                                      | 2.91                         |
| [Dockge](./src/dockge)                                        | 1                            |
| [Docker Registry](./src/docker-registry)                      | 3.0.0                        |
| [DuckDB](./src/duckdb)                                        | v1.1.3                       |
| [Easy Dataset](./src/easy-dataset)                            | 1.5.1                        |
| [Elasticsearch](./src/elasticsearch)                          | 8.16.1                       |
| [etcd](./src/etcd)                                            | 3.6.0                        |
| [Firecrawl](./src/firecrawl)                                  | latest                       |
| [frpc](./src/frpc)                                            | 0.64.0                       |
| [frps](./src/frps)                                            | 0.64.0                       |
| [Gitea Runner](./src/gitea-runner)                            | 0.2.13                       |
| [Gitea](./src/gitea)                                          | 1.24.6                       |
| [GitLab Runner](./src/gitlab-runner)                          | 17.10.1                      |
| [GitLab](./src/gitlab)                                        | 17.10.4-ce.0                 |
| [GPUStack](./src/gpustack)                                    | v0.5.3                       |
| [Grafana](./src/grafana)                                      | 12.1.1                       |
| [Halo](./src/halo)                                            | 2.21.9                       |
| [Harbor](./src/harbor)                                        | v2.12.0                      |
| [HashiCorp Consul](./src/consul)                              | 1.20.3                       |
| [IOPaint](./builds/io-paint)                                  | latest                       |
| [Jenkins](./src/jenkins)                                      | 2.486-lts                    |
| [JODConverter](./src/jodconverter)                            | latest                       |
| [Kestra](./src/kestra)                                        | latest-full                  |
| [Kibana](./src/kibana)                                        | 8.16.1                       |
| [Kodbox](./src/kodbox)                                        | 1.62                         |
| [Kong](./src/kong)                                            | 3.8.0                        |
| [Langflow](./src/langflow)                                    | latest                       |
| [Langfuse](./src/langfuse)                                    | 3.115.0                      |
| [LibreOffice](./src/libreoffice)                              | latest                       |
| [LiteLLM](./src/litellm)                                      | main-stable                  |
| [Logstash](./src/logstash)                                    | 8.16.1                       |
| [MariaDB Galera 集群](./src/mariadb-galera)                   | 11.7.2                       |
| [Milvus Standalone Embed](./src/milvus-standalone-embed)      | 2.6.2                        |
| [Milvus Standalone](./src/milvus-standalone)                  | 2.6.2                        |
| [Minecraft Bedrock Server](./src/minecraft-bedrock-server)    | latest                       |
| [MinerU SGLang](./src/mineru-sglang)                          | 2.2.2                        |
| [MinerU vLLM](./builds/mineru-vllm)                           | 2.6.4                        |
| [MinIO](./src/minio)                                          | RELEASE.2025-09-07T16-13-09Z |
| [MLflow](./src/mlflow)                                        | v2.20.2                      |
| [MongoDB ReplicaSet Single](./src/mongodb-replicaset-single)  | 8.0.13                       |
| [MongoDB ReplicaSet](./src/mongodb-replicaset)                | 8.0.13                       |
| [MongoDB Standalone](./src/mongodb-standalone)                | 8.0.13                       |
| [MySQL](./src/mysql)                                          | 9.4.0                        |
| [n8n](./src/n8n)                                              | 1.114.0                      |
| [Nacos](./src/nacos)                                          | v3.1.0                       |
| [NebulaGraph](./src/nebulagraph)                              | v3.8.0                       |
| [NexaSDK](./src/nexa-sdk)                                     | v0.2.62                      |
| [Neo4j](./src/neo4j)                                          | 5.27.4                       |
| [Netdata](./src/netdata)                                      | latest                       |
| [Nginx](./src/nginx)                                          | 1.29.1                       |
| [Node Exporter](./src/node-exporter)                          | v1.8.2                       |
| [OceanBase](./src/oceanbase)                                  | 4.3.3                        |
| [Odoo](./src/odoo)                                            | 19.0                         |
| [Ollama](./src/ollama)                                        | 0.12.0                       |
| [Open WebUI](./src/open-webui)                                | main                         |
| [Phoenix (Arize)](./src/phoenix)                              | 12.19.0                      |
| [Pingora Proxy Manager](./src/pingora-proxy-manager)          | v1.0.3                       |
| [Open WebUI Rust](./src/open-webui-rust)                      | latest                       |
| [OpenCoze](./src/opencoze)                                    | See Docs                     |
| [OpenCut](./src/opencut)                                      | latest                       |
| [OpenList](./src/openlist)                                    | latest                       |
| [OpenSearch](./src/opensearch)                                | 2.19.0                       |
| [PocketBase](./src/pocketbase)                                | 0.30.0                       |
| [Portainer](./src/portainer)                                  | 2.27.3-alpine                |
| [Portkey AI Gateway](./src/portkey-gateway)                   | latest                       |
| [PostgreSQL](./src/postgres)                                  | 17.6                         |
| [Prometheus](./src/prometheus)                                | 3.5.0                        |
| [PyTorch](./src/pytorch)                                      | 2.6.0                        |
| [Qdrant](./src/qdrant)                                        | 1.15.4                       |
| [RabbitMQ](./src/rabbitmq)                                    | 4.1.4                        |
| [Ray](./src/ray)                                              | 2.42.1                       |
| [Redpanda](./src/redpanda)                                    | v24.3.1                      |
| [Redis Cluster](./src/redis-cluster)                          | 8.2.1                        |
| [Redis](./src/redis)                                          | 8.2.1                        |
| [Renovate](./src/renovate)                                    | 42.52.5-full                 |
| [Restate Cluster](./src/restate-cluster)                      | 1.5.3                        |
| [Restate](./src/restate)                                      | 1.5.3                        |
| [SearXNG](./src/searxng)                                      | 2025.1.20-1ce14ef99          |
| [Stable Diffusion WebUI](./src/stable-diffusion-webui-docker) | latest                       |
| [Stirling-PDF](./src/stirling-pdf)                            | latest                       |
| [Temporal](./src/temporal)                                    | 1.24.2                       |
| [TiDB](./src/tidb)                                            | v8.5.0                       |
| [TiKV](./src/tikv)                                            | v8.5.0                       |
| [Trigger.dev](./src/trigger-dev)                              | v4.2.0                       |
| [Valkey Cluster](./src/valkey-cluster)                        | 8.0                          |
| [Valkey](./src/valkey)                                        | 8.0                          |
| [Verdaccio](./src/verdaccio)                                  | 6.1.2                        |
| [vLLM](./src/vllm)                                            | v0.8.0                       |
| [Windmill](./src/windmill)                                    | main                         |
| [ZooKeeper](./src/zookeeper)                                  | 3.9.3                        |

## MCP 服务器

| 服务                                                    | 版本   |
| ------------------------------------------------------- | ------ |
| [API Gateway](./mcp-servers/api-gateway)                | latest |
| [ArXiv MCP Server](./mcp-servers/arxiv-mcp-server)      | latest |
| [Basic Memory](./mcp-servers/basic-memory)              | latest |
| [ClickHouse](./mcp-servers/clickhouse)                  | latest |
| [Docker](./mcp-servers/docker)                          | latest |
| [Dockerhub](./mcp-servers/dockerhub)                    | latest |
| [E2B](./mcp-servers/e2b)                                | latest |
| [ElevenLabs](./mcp-servers/elevenlabs)                  | latest |
| [Fetch](./mcp-servers/fetch)                            | latest |
| [Firecrawl](./mcp-servers/firecrawl)                    | latest |
| [Filesystem](./mcp-servers/filesystem)                  | latest |
| [Grafana](./mcp-servers/grafana)                        | latest |
| [Markdownify](./mcp-servers/markdownify)                | latest |
| [Markitdown](./mcp-servers/markitdown)                  | latest |
| [Memory](./mcp-servers/memory)                          | latest |
| [MongoDB](./mcp-servers/mongodb)                        | latest |
| [Neo4j Cypher](./mcp-servers/neo4j-cypher)              | latest |
| [Neo4j Memory](./mcp-servers/neo4j-memory)              | latest |
| [Notion](./mcp-servers/notion)                          | latest |
| [OpenAPI Schema](./mcp-servers/openapi-schema)          | latest |
| [OpenAPI](./mcp-servers/openapi)                        | latest |
| [OpenWeather](./mcp-servers/openweather)                | latest |
| [Paper Search](./mcp-servers/paper-search)              | latest |
| [Playwright](./mcp-servers/playwright)                  | latest |
| [Redis MCP](./mcp-servers/redis-mcp)                    | latest |
| [Rust Filesystem](./mcp-servers/rust-mcp-filesystem)    | latest |
| [Sequential Thinking](./mcp-servers/sequentialthinking) | latest |
| [SQLite](./mcp-servers/sqlite)                          | latest |
| [Tavily](./mcp-servers/tavily)                          | latest |
| [Text to GraphQL](./mcp-servers/text-to-graphql)        | latest |
| [Time](./mcp-servers/time)                              | latest |
| [Wolfram Alpha](./mcp-servers/wolfram-alpha)            | latest |
| [YouTube Transcript](./mcp-servers/youtube-transcript)  | latest |

## 规范

1. 开箱即用
    - 配置应该是开箱即用的，无需额外步骤即可启动（最多提供 `.env` 文件）。
2. 命令简单
    - 每个项目提供单一的 `docker-compose.yaml` 文件；
    - 命令复杂度不应超过 `docker compose up -d`；若需要额外流程，请提供 `Makefile`；
    - 若服务需要初始化，优先使用 `healthcheck` 与 `depends_on` 的 `condition: service_healthy` 组织启动顺序。
3. 版本稳定
    - 固定到“最新稳定版”而非 `latest`；
    - 通过环境变量暴露镜像版本（如 `FOO_VERSION`）。
4. 配置约定
    - 尽量通过环境变量配置，而非复杂的命令行参数；
    - 敏感信息通过环境变量或挂载文件传递，不要硬编码；
    - 提供合理默认值，实现零配置可启动；
    - 必须提供带注释的 `.env.example`；
    - 环境变量命名建议：全大写、下划线分隔，按服务加前缀（如 `POSTGRES_*`），端口覆写统一用 `*_PORT_OVERRIDE`。
5. Profiles 规范
    - 对“可选组件/依赖”使用 Profiles；
    - 推荐命名：`gpu`（GPU 加速）、`metrics`（可观测性/导出器）、`dev`（开发特性）。
6. 跨平台与架构
    - 在镜像支持前提下，确保 Debian 12+/Ubuntu 22.04+、Windows 10+、macOS 12+ 可用；
    - 支持 x86-64 与 ARM64 架构尽可能一致；
    - 避免依赖仅在 Linux 主机存在的主机路径（例如 `/etc/localtime`、`/etc/timezone`），统一使用 `TZ` 环境变量传递时区。
7. 卷与挂载
    - 配置文件优先使用相对路径，增强跨平台兼容；
    - 数据目录优先使用“命名卷”，避免主机路径权限/兼容性问题；
    - 如需主机路径，建议提供顶层目录变量（如 `DATA_DIR`）。
8. 资源与日志
    - 必须限制 CPU/内存，防止资源打爆；
    - GPU 服务默认单卡：可使用 `deploy.resources.reservations.devices`（Compose 支持为 device_requests 映射）或 `gpus`；
    - 限制日志大小（`json-file`：`max-size`/`max-file`）。
9. 健康检查
    - 每个服务应提供 `healthcheck`，包括合适的 `interval`、`timeout`、`retries` 与 `start_period`；
    - 依赖链通过 `depends_on.condition: service_healthy` 组织。
10. 安全基线（能用则用）
    - 以非 root 运行（提供 `PUID`/`PGID` 或直接 `user: "1000:1000"`）；
    - 只读根文件系统（`read_only: true`），必要目录使用 `tmpfs`/可写挂载；
    - 最小权限：`cap_drop: ["ALL"]`，按需再 `cap_add`；
    - 避免使用 `container_name`（影响可扩缩与复用网络别名）；
    - 如需暴露 Docker 套接字等高危挂载，必须在文档中明确“风险与替代方案”。
11. 文档与可发现性
    - 提供清晰文档与示例（含初始化与管理员账号说明、必要的安全/许可说明）；
    - 提供对 LLM 友好的结构化文档；
    - 在 README 中标注主要环境变量与默认端口，并链接到 `README.md` / `README.zh.md`。

## 开源协议

[MIT License](./LICENSE).
