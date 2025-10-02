# Elasticsearch

[English](./README.md) | [中文](./README.zh.md)

This service deploys Elasticsearch, a distributed search and analytics engine.

## Services

- `elasticsearch`: The Elasticsearch service.

## Environment Variables

| Variable Name                         | Description                                         | Default Value    |
| ------------------------------------- | --------------------------------------------------- | ---------------- |
| ELASTICSEARCH_VERSION                 | Elasticsearch image version                         | `8.16.1`         |
| ELASTICSEARCH_HTTP_PORT_OVERRIDE      | Host port mapping for HTTP (maps to port 9200)      | 9200             |
| ELASTICSEARCH_TRANSPORT_PORT_OVERRIDE | Host port mapping for transport (maps to port 9300) | 9300             |
| ELASTICSEARCH_CLUSTER_NAME            | Name of the Elasticsearch cluster                   | `docker-cluster` |
| ELASTICSEARCH_DISCOVERY_TYPE          | Discovery type for single-node setup                | `single-node`    |
| ELASTICSEARCH_SECURITY_ENABLED        | Enable X-Pack security features                     | `false`          |
| ELASTICSEARCH_SSL_ENABLED             | Enable SSL/TLS                                      | `false`          |
| ELASTICSEARCH_HEAP_SIZE               | JVM heap size                                       | `1g`             |

Please modify the `.env` file as needed for your use case.

## Volumes

- `elasticsearch_data`: Elasticsearch data directory.
- `elasticsearch_logs`: Elasticsearch log directory.
- `./elasticsearch.yml`: Optional custom Elasticsearch configuration file.

## Usage

1. Start the service:

   ```bash
   docker compose up -d
   ```

2. Wait for Elasticsearch to be ready:

   ```bash
   docker compose logs -f elasticsearch
   ```

3. Test the connection:

   ```bash
   curl http://localhost:9200
   ```

## Basic Operations

```bash
# Check cluster health
curl http://localhost:9200/_cluster/health

# List all indices
curl http://localhost:9200/_cat/indices?v

# Create an index
curl -X PUT "localhost:9200/my-index"

# Index a document
curl -X POST "localhost:9200/my-index/_doc" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "age": 30}'

# Search documents
curl -X GET "localhost:9200/my-index/_search" \
  -H "Content-Type: application/json" \
  -d '{"query": {"match_all": {}}}'
```

## Memory Configuration

Elasticsearch requires sufficient memory to operate effectively. The default configuration allocates 1GB of heap memory. For production environments, consider:

- Setting `ELASTICSEARCH_HEAP_SIZE` to 50% of available RAM (but not more than 31GB)
- Ensuring the host has at least 2GB of RAM available
- Configuring swap memory appropriately

## Health Check

The service includes a health check that verifies Elasticsearch cluster health.

## Security Notes

- This configuration disables security features for ease of development
- For production, enable X-Pack security, SSL/TLS, and authentication
- Configure proper network security and firewall rules
- Regularly backup your indices and update Elasticsearch version
