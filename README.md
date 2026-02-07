# Compose Anything

[中文说明](README.zh.md) | [English](README.md)

Compose Anything helps users quickly deploy various services by providing a set of high-quality Docker Compose configuration files. These configurations constrain resource usage, can be easily migrated to systems like K8S, and are easy to understand and modify.

## Build Services

These services require building custom Docker images from source.

| Service                                     | Version |
| ------------------------------------------- | ------- |
| [Debian DinD](./builds/debian-dind)         | 0.1.2   |
| [goose](./builds/goose)                     | 1.18.0  |
| [IOPaint](./builds/io-paint)                | 1.6.0   |
| [K3s inside DinD](./builds/k3s-inside-dind) | 0.2.2   |
| [MinerU vLLM](./builds/mineru)              | 2.7.6   |

## Supported Services

| Service                                                        | Version             |
| -------------------------------------------------------------- | ------------------- |
| [Apache APISIX](./src/apisix)                                  | 3.13.0              |
| [Apache Cassandra](./src/cassandra)                            | 5.0.2               |
| [Apache Flink](./src/flink)                                    | 1.20.0              |
| [Apache HBase](./src/hbase)                                    | 2.6                 |
| [Apache HTTP Server](./src/apache)                             | 2.4.62              |
| [Apache Kafka](./src/kafka)                                    | 7.8.0               |
| [Apache Pulsar](./src/pulsar)                                  | 4.0.7               |
| [Apache RocketMQ](./src/rocketmq)                              | 5.3.1               |
| [Bifrost Gateway](./src/bifrost-gateway)                       | v1.3.63             |
| [Bolt.diy](./apps/bolt-diy)                                    | latest              |
| [Budibase](./src/budibase)                                     | 3.23.0              |
| [BuildingAI](./apps/buildingai)                                | latest              |
| [Bytebot](./src/bytebot)                                       | edge                |
| [Clash](./src/clash)                                           | 1.18.0              |
| [ClickHouse](./src/clickhouse)                                 | 24.11.1             |
| [Conductor](./src/conductor)                                   | latest              |
| [DeepTutor](./apps/deeptutor)                                  | latest              |
| [Dify](./apps/dify)                                            | 0.18.2              |
| [DNSMasq](./src/dnsmasq)                                       | 2.91                |
| [Dockge](./src/dockge)                                         | 1                   |
| [Docker Android Emulator](./src/docker-android)                | api-33              |
| [Docker Registry](./src/docker-registry)                       | 3.0.0               |
| [Doris](./src/doris)                                           | 3.0.0               |
| [DuckDB](./src/duckdb)                                         | v1.1.3              |
| [Easy Dataset](./apps/easy-dataset)                            | 1.5.1               |
| [Elasticsearch](./src/elasticsearch)                           | 9.3.0               |
| [etcd](./src/etcd)                                             | 3.6.0               |
| [FalkorDB](./src/falkordb)                                     | v4.14.11            |
| [Firecrawl](./src/firecrawl)                                   | latest              |
| [Flowise](./src/flowise)                                       | 3.0.12              |
| [frpc](./src/frpc)                                             | 0.65.0              |
| [frps](./src/frps)                                             | 0.65.0              |
| [Gitea Runner](./src/gitea-runner)                             | 0.2.13              |
| [Gitea](./src/gitea)                                           | 1.25.4-rootless     |
| [GitLab Runner](./src/gitlab-runner)                           | 17.10.1             |
| [GitLab](./src/gitlab)                                         | 18.8.3-ce.0         |
| [GPUStack](./src/gpustack)                                     | v0.5.3              |
| [Grafana](./src/grafana)                                       | 12.3.2              |
| [Grafana Loki](./src/loki)                                     | 3.3.2               |
| [Grafana Tempo](./src/tempo)                                   | 2.7.2               |
| [Halo](./src/halo)                                             | 2.21.9              |
| [Harbor](./src/harbor)                                         | v2.12.0             |
| [HashiCorp Consul](./src/consul)                               | 1.20.3              |
| [InfluxDB](./src/influxdb)                                     | 2.8.0               |
| [Jenkins](./src/jenkins)                                       | 2.541-lts           |
| [JODConverter](./src/jodconverter)                             | latest              |
| [Kestra](./src/kestra)                                         | latest-full         |
| [Kibana](./src/kibana)                                         | 8.16.1              |
| [Kodbox](./src/kodbox)                                         | 1.62                |
| [Kong](./src/kong)                                             | 3.8.0               |
| [Langflow](./apps/langflow)                                    | latest              |
| [Langfuse](./apps/langfuse)                                    | 3.115.0             |
| [LibreOffice](./src/libreoffice)                               | latest              |
| [libSQL Server](./src/libsql)                                  | latest              |
| [LiteLLM](./src/litellm)                                       | main-stable         |
| [llama.cpp](./src/llama.cpp)                                   | server              |
| [LMDeploy](./src/lmdeploy)                                     | v0.11.1             |
| [Logstash](./src/logstash)                                     | 8.16.1              |
| [MariaDB Galera Cluster](./src/mariadb-galera)                 | 11.7.2              |
| [Memos](./src/memos)                                           | 0.25.3              |
| [Milvus Standalone Embed](./src/milvus-standalone-embed)       | v2.6.7              |
| [Milvus Standalone](./src/milvus-standalone)                   | v2.6.7              |
| [Minecraft Bedrock Server](./src/minecraft-bedrock-server)     | latest              |
| [MinIO](./src/minio)                                           | 0.20260202          |
| [MLflow](./src/mlflow)                                         | v2.20.2             |
| [MoltBot](./apps/moltbot)                                      | main                |
| [MongoDB ReplicaSet Single](./src/mongodb-replicaset-single)   | 8.2.3               |
| [MongoDB ReplicaSet](./src/mongodb-replicaset)                 | 8.2.3               |
| [MongoDB Standalone](./src/mongodb-standalone)                 | 8.2.3               |
| [MySQL](./src/mysql)                                           | 9.4.0               |
| [n8n](./apps/n8n)                                              | 1.114.0             |
| [Nanobot](./apps/nanobot)                                      | v0.1.3.post4        |
| [Nacos](./src/nacos)                                           | v3.1.0              |
| [NebulaGraph](./src/nebulagraph)                               | v3.8.0              |
| [NexaSDK](./src/nexa-sdk)                                      | v0.2.62             |
| [Neo4j](./src/neo4j)                                           | 5.27.4              |
| [Netdata](./src/netdata)                                       | latest              |
| [Nginx](./src/nginx)                                           | 1.28.2              |
| [Node Exporter](./src/node-exporter)                           | v1.8.2              |
| [OceanBase](./src/oceanbase)                                   | 4.3.3               |
| [Odoo](./src/odoo)                                             | 19.0                |
| [Ollama](./src/ollama)                                         | 0.14.3              |
| [Open WebUI](./src/open-webui)                                 | main                |
| [Phoenix (Arize)](./src/phoenix)                               | 12.31.2-nonroot     |
| [Pingora Proxy Manager](./src/pingora-proxy-manager)           | v1.0.3              |
| [Open WebUI Rust](./src/open-webui-rust)                       | latest              |
| [OpenCode](./src/opencode)                                     | 1.1.27              |
| [OpenCoze](./apps/opencoze)                                    | See Docs            |
| [OpenCut](./src/opencut)                                       | latest              |
| [OpenList](./src/openlist)                                     | latest              |
| [OpenLIT](./apps/openlit)                                      | latest              |
| [OpenSandbox](./apps/opensandbox)                              | v1.0.5              |
| [OpenObserve](./apps/openobserve)                              | v0.50.0             |
| [OpenSearch](./src/opensearch)                                 | 2.19.0              |
| [OpenTelemetry Collector](./src/otel-collector)                | 0.115.1             |
| [Overleaf](./src/overleaf)                                     | 5.2.1               |
| [PocketBase](./src/pocketbase)                                 | 0.30.0              |
| [Podman](./src/podman)                                         | v5.7.1              |
| [Pogocache](./src/pogocache)                                   | 1.3.1               |
| [Portainer](./src/portainer)                                   | 2.27.3-alpine       |
| [Portkey AI Gateway](./src/portkey-gateway)                    | latest              |
| [PostgreSQL](./src/postgres)                                   | 17.6                |
| [Prometheus](./src/prometheus)                                 | 3.5.1               |
| [PyTorch](./src/pytorch)                                       | 2.6.0               |
| [Qdrant](./src/qdrant)                                         | 1.15.4              |
| [RabbitMQ](./src/rabbitmq)                                     | 4.2.3               |
| [Ray](./src/ray)                                               | 2.42.1              |
| [Redpanda](./src/redpanda)                                     | v24.3.1             |
| [Redis Cluster](./src/redis-cluster)                           | 8.2.1               |
| [Redis](./src/redis)                                           | 8.2.1               |
| [Renovate](./src/renovate)                                     | 42.85.4-full        |
| [Restate Cluster](./src/restate-cluster)                       | 1.5.3               |
| [Restate](./src/restate)                                       | 1.5.3               |
| [SearXNG](./src/searxng)                                       | 2025.1.20-1ce14ef99 |
| [Selenium](./src/selenium)                                     | 144.0-20260120      |
| [SigNoz](./src/signoz)                                         | 0.55.0              |
| [Sim](./apps/sim)                                              | latest              |
| [Stable Diffusion WebUI](./apps/stable-diffusion-webui-docker) | latest              |
| [Stirling-PDF](./apps/stirling-pdf)                            | latest              |
| [Temporal](./src/temporal)                                     | 1.24.2              |
| [TiDB](./src/tidb)                                             | v8.5.0              |
| [TiKV](./src/tikv)                                             | v8.5.0              |
| [Trigger.dev](./src/trigger-dev)                               | v4.2.0              |
| [TrailBase](./src/trailbase)                                   | 0.22.4              |
| [Valkey Cluster](./src/valkey-cluster)                         | 8.0                 |
| [Valkey](./src/valkey)                                         | 8.0                 |
| [Verdaccio](./src/verdaccio)                                   | 6.1.2               |
| [vLLM](./src/vllm)                                             | v0.13.0             |
| [Windmill](./src/windmill)                                     | main                |
| [ZooKeeper](./src/zookeeper)                                   | 3.9.3               |

## MCP Servers

| Server                                                  | Version |
| ------------------------------------------------------- | ------- |
| [API Gateway](./mcp-servers/api-gateway)                | latest  |
| [ArXiv MCP Server](./mcp-servers/arxiv-mcp-server)      | latest  |
| [Basic Memory](./mcp-servers/basic-memory)              | latest  |
| [ClickHouse](./mcp-servers/clickhouse)                  | latest  |
| [Docker](./mcp-servers/docker)                          | latest  |
| [Dockerhub](./mcp-servers/dockerhub)                    | latest  |
| [E2B](./mcp-servers/e2b)                                | latest  |
| [ElevenLabs](./mcp-servers/elevenlabs)                  | latest  |
| [Fetch](./mcp-servers/fetch)                            | latest  |
| [Firecrawl](./mcp-servers/firecrawl)                    | latest  |
| [Filesystem](./mcp-servers/filesystem)                  | latest  |
| [Grafana](./mcp-servers/grafana)                        | latest  |
| [Markdownify](./mcp-servers/markdownify)                | latest  |
| [Markitdown](./mcp-servers/markitdown)                  | latest  |
| [Memory](./mcp-servers/memory)                          | latest  |
| [MongoDB](./mcp-servers/mongodb)                        | latest  |
| [Neo4j Cypher](./mcp-servers/neo4j-cypher)              | latest  |
| [Neo4j Memory](./mcp-servers/neo4j-memory)              | latest  |
| [Notion](./mcp-servers/notion)                          | latest  |
| [OpenAPI Schema](./mcp-servers/openapi-schema)          | latest  |
| [OpenAPI](./mcp-servers/openapi)                        | latest  |
| [OpenWeather](./mcp-servers/openweather)                | latest  |
| [Paper Search](./mcp-servers/paper-search)              | latest  |
| [Playwright](./mcp-servers/playwright)                  | latest  |
| [Redis MCP](./mcp-servers/redis-mcp)                    | latest  |
| [Rust Filesystem](./mcp-servers/rust-mcp-filesystem)    | latest  |
| [Sequential Thinking](./mcp-servers/sequentialthinking) | latest  |
| [SQLite](./mcp-servers/sqlite)                          | latest  |
| [Tavily](./mcp-servers/tavily)                          | latest  |
| [Text to GraphQL](./mcp-servers/text-to-graphql)        | latest  |
| [Time](./mcp-servers/time)                              | latest  |
| [Wolfram Alpha](./mcp-servers/wolfram-alpha)            | latest  |
| [YouTube Transcript](./mcp-servers/youtube-transcript)  | latest  |

## Guidelines

1. Out-of-the-box
    - Configurations should work out-of-the-box with no extra steps (at most, provide a `.env` file).
2. Simple commands
    - Each project ships a single `docker-compose.yaml` file.
    - Command complexity should not exceed `docker compose up -d`; if more is needed, provide a `Makefile`.
    - For initialization, prefer `healthcheck` with `depends_on` using `condition: service_healthy` to orchestrate startup order.
3. Stable versions
    - Pin to the latest stable version instead of `latest`.
    - Expose image versions via environment variables (e.g., `FOO_VERSION`).
4. Configuration conventions
    - Prefer environment variables over complex CLI flags;
    - Pass secrets via env vars or mounted files, never hardcode;
    - Provide sensible defaults to enable zero-config startup;
    - A commented `.env.example` is required;
    - Env var naming: UPPER_SNAKE_CASE with service prefix (e.g., `POSTGRES_*`); use `*_PORT_OVERRIDE` for host port overrides.
5. Profiles
    - Use Profiles for optional components/dependencies;
    - Recommended names: `gpu` (acceleration), `metrics` (observability/exporters), `dev` (dev-only features).
6. Cross-platform & architectures
    - Where images support it, ensure Debian 12+/Ubuntu 22.04+, Windows 10+, macOS 12+ work;
    - Support x86-64 and ARM64 as consistently as possible;
    - Avoid Linux-only host paths like `/etc/localtime` and `/etc/timezone`; prefer `TZ` env var for time zone.
7. Volumes & mounts
    - Prefer relative paths for configuration to improve portability;
    - Prefer named volumes for data directories to avoid permission/compat issues of host paths;
    - If host paths are necessary, provide a top-level directory variable (e.g., `DATA_DIR`).
8. Resources & logging
    - Always limit CPU and memory to prevent resource exhaustion;
    - For GPU services, enable a single GPU by default via `deploy.resources.reservations.devices` (maps to device requests) or `gpus` where applicable;
    - Limit logs (`json-file` driver: `max-size`/`max-file`).
9. Healthchecks
    - Every service should define a `healthcheck` with suitable `interval`, `timeout`, `retries`, and `start_period`;
    - Use `depends_on.condition: service_healthy` for dependency chains.
10. Security baseline (apply when possible)
    - Run as non-root (expose `PUID`/`PGID` or set `user: "1000:1000"`);
    - Read-only root filesystem (`read_only: true`), use `tmpfs`/writable mounts for required paths;
    - Least privilege: `cap_drop: ["ALL"]`, add back only what’s needed via `cap_add`;
    - Avoid `container_name` (hurts scaling and reusable network aliases);
    - If exposing Docker socket or other high-risk mounts, clearly document risks and alternatives.
11. Documentation & discoverability
    - Provide clear docs and examples (include admin/initialization notes, and security/license notes when relevant);
    - Keep docs LLM-friendly;
    - List primary env vars and default ports in the README, and link to `README.md` / `README.zh.md`.

## License

[MIT License](./LICENSE).
