# Compose Anything

Compose Anything helps users quickly deploy various services by providing a set of high-quality Docker Compose configuration files. These configurations constrain resource usage, can be easily migrated to systems like K8S, and are easy to understand and modify.

## Supported Services

| Service                                                  | Version                      |
| -------------------------------------------------------- | ---------------------------- |
| [Apache APISIX](./src/apisix)                            | 3.13.0                       |
| [Apache Cassandra](./src/cassandra)                      | 5.0.2                        |
| [Apache HTTP Server](./src/apache)                       | 2.4.62                       |
| [Apache Kafka](./src/kafka)                              | 7.8.0                        |
| [Bifrost Gateway](./src/bifrost-gateway)                 | 1.2.15                       |
| [Bytebot](./src/bytebot)                                 | edge                         |
| [Clash](./src/clash)                                     | 1.18.0                       |
| [Dify](./src/dify)                                       | 0.18.2                       |
| [Docker Registry](./src/docker-registry)                 | 3.0.0                        |
| [Elasticsearch](./src/elasticsearch)                     | 8.16.1                       |
| [etcd](./src/etcd)                                       | 3.6.0                        |
| [frpc](./src/frpc)                                       | 0.64.0                       |
| [frps](./src/frps)                                       | 0.64.0                       |
| [Gitea Runner](./src/gitea-runner)                       | 0.2.12                       |
| [Gitea](./src/gitea)                                     | 1.24.6                       |
| [GitLab Runner](./src/gitlab-runner)                     | 17.10.1                      |
| [GitLab](./src/gitlab)                                   | 17.10.4-ce.0                 |
| [GPUStack](./src/gpustack)                               | v0.5.3                       |
| [Grafana](./src/grafana)                                 | 12.1.1                       |
| [Halo](./src/halo)                                       | 2.21.9                       |
| [Harbor](./src/harbor)                                   | v2.12.0                      |
| [HashiCorp Consul](./src/consul)                         | 1.20.3                       |
| [IOPaint](./src/io-paint)                                | latest                       |
| [Jenkins](./src/jenkins)                                 | 2.486-lts                    |
| [Kibana](./src/kibana)                                   | 8.16.1                       |
| [Kodbox](./src/kodbox)                                   | 1.62                         |
| [Kong](./src/kong)                                       | 3.8.0                        |
| [Langfuse](./src/langfuse)                               | 3.115.0                      |
| [Logstash](./src/logstash)                               | 8.16.1                       |
| [Milvus Standalone Embed](./src/milvus-standalone-embed) | 2.6.2                        |
| [Milvus Standalone](./src/milvus-standalone)             | 2.6.2                        |
| [MinerU SGALNG](./src/mineru-sgalng)                     | 2.2.2                        |
| [MinerU v2](./src/mineru-v2)                             | 2.5.3                        |
| [MinIO](./src/minio)                                     | RELEASE.2025-09-07T16-13-09Z |
| [MongoDB ReplicaSet](./src/mongodb-replicaset)           | 8.0.13                       |
| [MongoDB Standalone](./src/mongodb-standalone)           | 8.0.13                       |
| [MySQL](./src/mysql)                                     | 9.4.0                        |
| [n8n](./src/n8n)                                         | 1.114.0                      |
| [Nacos](./src/nacos)                                     | v3.1.0                       |
| [NebulaGraph](./src/nebulagraph)                         | v3.8.0                       |
| [Neo4j](./src/neo4j)                                     | 5.27.4                       |
| [Nginx](./src/nginx)                                     | 1.29.1                       |
| [Node Exporter](./src/node-exporter)                     | v1.8.2                       |
| [Odoo](./src/odoo)                                       | 19.0                         |
| [Ollama](./src/ollama)                                   | 0.12.0                       |
| [Open WebUI](./src/open-webui)                           | main                         |
| [OpenCoze](./src/opencoze)                               | See Docs                     |
| [OpenCut](./src/opencut)                                 | latest                       |
| [OpenList](./src/openlist)                               | latest                       |
| [PocketBase](./src/pocketbase)                           | 0.30.0                       |
| [PostgreSQL](./src/postgres)                             | 17.6                         |
| [Prometheus](./src/prometheus)                           | 3.5.0                        |
| [Qdrant](./src/qdrant)                                   | 1.15.4                       |
| [RabbitMQ](./src/rabbitmq)                               | 4.1.4                        |
| [Redis Cluster](./src/redis-cluster)                     | 8.2.1                        |
| [Redis](./src/redis)                                     | 8.2.1                        |
| [vLLM](./src/vllm)                                       | v0.8.0                       |
| [ZooKeeper](./src/zookeeper)                             | 3.9.3                        |

## Guidelines

1. **Out-of-the-box**: Configurations should work out-of-the-box, requiring no setup to start (at most, provide a `.env` file).
2. **Simple Commands**
    - Each project provides a single `docker-compose.yaml` file.
    - Command complexity should not exceed the `docker compose` command; if it does, provide a `Makefile`.
    - If a service requires initialization, use `depends_on` to simulate Init containers.
3. **Stable Versions**
    - Provide the latest stable image version instead of `latest`.
    - Allow version configuration via environment variables.
4. **Highly Configurable**
    - Prefer configuration via environment variables rather than complex command-line arguments.
    - Sensitive information like passwords should be passed via environment variables or mounted files, not hardcoded.
    - Provide reasonable defaults so services can start with zero configuration.
    - Provide a well-commented `.env.example` file to help users get started quickly.
    - Use Profiles for optional dependencies.
5. **Cross-Platform**: (Where supported by the image) Ensure compatibility with major platforms.
    - Compatibility: Debian 12+/Ubuntu 22.04+, Windows 10+, macOS 12+.
    - Support multiple architectures where possible, such as x86-64 and ARM64.
6. **Careful Mounting**
    - Use relative paths for configuration file mounts to ensure cross-platform compatibility.
    - Use named volumes for data directories to avoid permission and compatibility issues with host path mounts.
7. **Default Resource Limits**
    - Limit CPU and memory usage for each service to prevent accidental resource exhaustion.
    - Limit log file size to prevent logs from filling up the disk.
    - For GPU services, enable single GPU by default.
8. **Comprehensive Documentation**
    - Provide good documentation and examples to help users get started and understand the configurations.
    - Clearly explain how to initialize accounts, admin accounts, etc.
    - Provide security and license notes when necessary.
    - Offer LLM-friendly documentation for easy querying and understanding by language models.
9. **Best Practices**: Follow other best practices to ensure security, performance, and maintainability.

## License

MIT License.
