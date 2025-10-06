# Logstash

[Logstash](https://www.elastic.co/logstash) is a free and open server-side data processing pipeline that ingests data from a multitude of sources, transforms it, and then sends it to your favorite "stash."

## Features

- Data Ingestion: Collect data from various sources
- Data Transformation: Parse, filter, and enrich data
- Data Output: Send data to Elasticsearch, databases, or other destinations
- Plugin Ecosystem: Extensive plugin library for inputs, filters, and outputs

## Quick Start

Start Logstash:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `LOGSTASH_VERSION`: Logstash version (default: `8.16.1`)
- `LOGSTASH_BEATS_PORT_OVERRIDE`: Beats input port (default: `5044`)
- `LOGSTASH_TCP_PORT_OVERRIDE`: TCP input port (default: `5000`)
- `LOGSTASH_UDP_PORT_OVERRIDE`: UDP input port (default: `5000`)
- `LOGSTASH_HTTP_PORT_OVERRIDE`: HTTP API port (default: `9600`)
- `LOGSTASH_MONITORING_ENABLED`: Enable monitoring (default: `false`)
- `ELASTICSEARCH_HOSTS`: Elasticsearch hosts (default: `http://elasticsearch:9200`)
- `ELASTICSEARCH_USERNAME`: Elasticsearch username
- `ELASTICSEARCH_PASSWORD`: Elasticsearch password
- `LS_JAVA_OPTS`: Java options (default: `-Xmx1g -Xms1g`)
- `LOGSTASH_PIPELINE_WORKERS`: Number of pipeline workers (default: `2`)
- `LOGSTASH_PIPELINE_BATCH_SIZE`: Pipeline batch size (default: `125`)
- `LOGSTASH_PIPELINE_BATCH_DELAY`: Pipeline batch delay in ms (default: `50`)
- `LOGSTASH_LOG_LEVEL`: Log level (default: `info`)

## Pipeline Configuration

Create pipeline configuration files in the `./pipeline` directory. Example `logstash.conf`:

```conf
input {
  beats {
    port => 5044
  }
  tcp {
    port => 5000
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}

output {
  elasticsearch {
    hosts => ["${ELASTICSEARCH_HOSTS}"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
  stdout {
    codec => rubydebug
  }
}
```

## Access

- HTTP API: <http://localhost:9600>
- Monitoring: <http://localhost:9600/_node/stats>

## Health Check

Check Logstash status:

```bash
curl http://localhost:9600/_node/stats
```

## Custom Configuration

Uncomment the configuration volumes in `docker-compose.yaml` and create:

- `logstash.yml`: Main configuration
- `pipelines.yml`: Pipeline definitions

## Resources

- Resource Limits: 1.5 CPU, 2G RAM
- Resource Reservations: 0.5 CPU, 1G RAM
