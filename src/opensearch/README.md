# OpenSearch

[English](./README.md) | [中文](./README.zh.md)

This service deploys OpenSearch (Elasticsearch fork) with OpenSearch Dashboards (Kibana fork).

## Services

- `opensearch`: OpenSearch server for search and analytics.
- `opensearch-dashboards`: OpenSearch Dashboards for visualization.

## Environment Variables

| Variable Name                          | Description                   | Default Value        |
| -------------------------------------- | ----------------------------- | -------------------- |
| OPENSEARCH_VERSION                     | OpenSearch image version      | `2.19.0`             |
| OPENSEARCH_DASHBOARDS_VERSION          | OpenSearch Dashboards version | `2.19.0`             |
| CLUSTER_NAME                           | Cluster name                  | `opensearch-cluster` |
| OPENSEARCH_HEAP_SIZE                   | JVM heap size                 | `512m`               |
| OPENSEARCH_ADMIN_PASSWORD              | Admin password                | `Admin@123`          |
| DISABLE_SECURITY_PLUGIN                | Disable security plugin       | `false`              |
| OPENSEARCH_PORT_OVERRIDE               | OpenSearch API port           | `9200`               |
| OPENSEARCH_PERF_ANALYZER_PORT_OVERRIDE | Performance Analyzer port     | `9600`               |
| OPENSEARCH_DASHBOARDS_PORT_OVERRIDE    | Dashboards UI port            | `5601`               |

Please modify the `.env` file as needed for your use case.

## Volumes

- `opensearch_data`: OpenSearch data storage.

## Usage

### Start the Services

```bash
docker-compose up -d
```

### Access OpenSearch

OpenSearch API:

```bash
curl -XGET https://localhost:9200 -u 'admin:Admin@123' --insecure
```

### Access OpenSearch Dashboards

Open your browser and navigate to:

```text
http://localhost:5601
```

Login with username `admin` and the password set in `OPENSEARCH_ADMIN_PASSWORD`.

### Create an Index

```bash
curl -XPUT https://localhost:9200/my-index -u 'admin:Admin@123' --insecure
```

### Index a Document

```bash
curl -XPOST https://localhost:9200/my-index/_doc -u 'admin:Admin@123' --insecure \
  -H 'Content-Type: application/json' \
  -d '{"title": "Hello OpenSearch", "content": "This is a test document"}'
```

### Search Documents

```bash
curl -XGET https://localhost:9200/my-index/_search -u 'admin:Admin@123' --insecure \
  -H 'Content-Type: application/json' \
  -d '{"query": {"match": {"title": "Hello"}}}'
```

## Features

- **Full-Text Search**: Advanced search capabilities with relevance scoring
- **Analytics**: Real-time data analysis and aggregations
- **Visualization**: Rich dashboards with OpenSearch Dashboards
- **Security**: Built-in security plugin with authentication and encryption
- **RESTful API**: Easy integration with any programming language
- **Scalable**: Single-node for development, cluster mode for production

## Notes

- Default admin password must contain at least 8 characters with uppercase, lowercase, digit, and special character
- For production, change the admin password and consider using external certificates
- JVM heap size should be set to 50% of available memory (max 31GB)
- Security plugin can be disabled for testing by setting `DISABLE_SECURITY_PLUGIN=true`
- For cluster mode, add more nodes and configure `discovery.seed_hosts`

## License

OpenSearch is licensed under the Apache License 2.0.
