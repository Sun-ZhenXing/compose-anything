# Kibana

[Kibana](https://www.elastic.co/kibana) is a free and open user interface that lets you visualize your Elasticsearch data and navigate the Elastic Stack.

## Features

- Data Visualization: Create beautiful visualizations and dashboards
- Search and Filter: Powerful search capabilities
- Machine Learning: Detect anomalies and patterns
- Alerting: Set up alerts based on your data
- Security: User authentication and authorization

## Quick Start

Start Kibana (requires Elasticsearch):

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `KIBANA_VERSION`: Kibana version (default: `8.16.1`)
- `KIBANA_PORT_OVERRIDE`: HTTP port (default: `5601`)
- `ELASTICSEARCH_HOSTS`: Elasticsearch hosts (default: `http://elasticsearch:9200`)
- `ELASTICSEARCH_USERNAME`: Elasticsearch username
- `ELASTICSEARCH_PASSWORD`: Elasticsearch password
- `KIBANA_SECURITY_ENABLED`: Enable security (default: `false`)
- `KIBANA_ENCRYPTION_KEY`: Encryption key for saved objects
- `KIBANA_LOG_LEVEL`: Log level (default: `info`)

## Access

- Web UI: <http://localhost:5601>

## Prerequisites

Kibana requires Elasticsearch to be running. Make sure Elasticsearch is accessible at the configured `ELASTICSEARCH_HOSTS`.

## Custom Configuration

Uncomment the configuration volume in `docker-compose.yaml` and create `kibana.yml`:

```yaml
server.name: kibana
server.host: 0.0.0.0
elasticsearch.hosts: ['http://elasticsearch:9200']
monitoring.ui.container.elasticsearch.enabled: true
```

## Health Check

Check Kibana status:

```bash
curl http://localhost:5601/api/status
```

## Resources

- Resource Limits: 1 CPU, 1G RAM
- Resource Reservations: 0.25 CPU, 512M RAM

## Common Tasks

### Create Index Pattern

1. Navigate to Management → Stack Management → Index Patterns
2. Click "Create index pattern"
3. Enter your index pattern (e.g., `logstash-*`)
4. Select the time field
5. Click "Create index pattern"

### Create Visualization

1. Navigate to Analytics → Visualize Library
2. Click "Create visualization"
3. Select visualization type
4. Configure the visualization
5. Save the visualization

## Integration

Kibana works with:

- Elasticsearch (required)
- Logstash (optional)
- Beats (optional)
- APM Server (optional)
