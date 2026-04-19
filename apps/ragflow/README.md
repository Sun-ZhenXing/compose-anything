# RAGFlow

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://ragflow.io/docs>.

This service deploys RAGFlow, an open-source Retrieval-Augmented Generation engine based on deep document understanding. It provides intelligent question answering over complex documents (PDFs, Word, PowerPoint, etc.) with accurate citation and citation tracing.

> **Platform note**: This stack is **x86-64 (amd64) only**. ARM64 is not supported by the official image.
>
> **Resource note**: Elasticsearch alone requires ~2 GB RAM. Provision at least **8 GB RAM** total before starting.

## Services

- **ragflow**: The RAGFlow web application and API server (Nginx on port 80, API on port 9380).
- **es01**: Elasticsearch single-node cluster for vector and full-text search.
- **mysql**: MySQL 8 database for metadata and workflow state.
- **redis**: Redis for task queues and caching.
- **minio**: S3-compatible object storage for document and chunk storage.

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Update the secrets in `.env`:

   ```
   SECRET_KEY, MYSQL_PASSWORD, REDIS_PASSWORD, MINIO_PASSWORD
   ```

3. Start the services (initial startup may take 2–5 minutes):

   ```bash
   docker compose up -d
   ```

4. Open `http://localhost` and register the first admin account.

## Core Environment Variables

| Variable               | Description                                              | Default                          |
| ---------------------- | -------------------------------------------------------- | -------------------------------- |
| `RAGFLOW_VERSION`      | RAGFlow image version                                    | `v0.24.0`                        |
| `RAGFLOW_PORT_OVERRIDE`| Host port for the web UI                                 | `80`                             |
| `SECRET_KEY`           | Application secret key — **CHANGEME**                    | placeholder                      |
| `MYSQL_PASSWORD`       | MySQL root password (also used by RAGFlow)               | `ragflow`                        |
| `REDIS_PASSWORD`       | Redis authentication password                            | `redispassword`                  |
| `MINIO_USER`           | MinIO root user                                          | `minioadmin`                     |
| `MINIO_PASSWORD`       | MinIO root password                                      | `minioadmin`                     |
| `MINIO_CONSOLE_PORT_OVERRIDE` | MinIO web console host port                       | `9001`                           |

## Volumes

- `ragflow_logs`: RAGFlow application logs.
- `ragflow_es_data`: Elasticsearch index data.
- `ragflow_mysql_data`: MySQL database files.
- `ragflow_redis_data`: Redis persistence.
- `ragflow_minio_data`: Object storage for documents and embeddings.

## Ports

- **80**: RAGFlow web UI and API (via Nginx)
- **9001**: MinIO web console

## Resource Requirements

| Service       | CPU Limit | Memory Limit |
| ------------- | --------- | ------------ |
| ragflow       | 4         | 4 GB         |
| elasticsearch | 2         | 2 GB         |
| mysql         | 1         | 1 GB         |
| redis         | 0.5       | 512 MB       |
| minio         | 1         | 1 GB         |

Total recommended: **8+ GB RAM**, **4+ CPU cores**.

## Documentation

- [RAGFlow Docs](https://ragflow.io/docs)
- [GitHub](https://github.com/infiniflow/ragflow)
