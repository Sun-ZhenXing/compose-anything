# MLflow

[English](./README.md) | [中文](./README.zh.md)

This service deploys MLflow with PostgreSQL backend and MinIO artifact storage.

## Services

- `mlflow`: MLflow tracking server.
- `postgres`: PostgreSQL database for MLflow metadata.
- `minio`: MinIO server for artifact storage (S3-compatible).
- `minio-init`: Initialization service to create the MLflow bucket.

## Environment Variables

| Variable Name               | Description                | Default Value                  |
| --------------------------- | -------------------------- | ------------------------------ |
| MLFLOW_VERSION              | MLflow image version       | `v2.20.2`                      |
| POSTGRES_VERSION            | PostgreSQL image version   | `17.6-alpine`                  |
| POSTGRES_USER               | PostgreSQL username        | `mlflow`                       |
| POSTGRES_PASSWORD           | PostgreSQL password        | `mlflow`                       |
| POSTGRES_DB                 | PostgreSQL database name   | `mlflow`                       |
| MINIO_VERSION               | MinIO image version        | `RELEASE.2025-01-07T16-13-09Z` |
| MINIO_MC_VERSION            | MinIO client version       | `RELEASE.2025-01-07T17-25-52Z` |
| MINIO_ROOT_USER             | MinIO root username        | `minio`                        |
| MINIO_ROOT_PASSWORD         | MinIO root password        | `minio123`                     |
| MINIO_BUCKET                | MinIO bucket for artifacts | `mlflow`                       |
| MLFLOW_PORT_OVERRIDE        | MLflow server port         | `5000`                         |
| MINIO_PORT_OVERRIDE         | MinIO API port             | `9000`                         |
| MINIO_CONSOLE_PORT_OVERRIDE | MinIO Console port         | `9001`                         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `postgres_data`: PostgreSQL data storage.
- `minio_data`: MinIO data storage for artifacts.

## Usage

### Access MLflow UI

After starting the services, access the MLflow UI at:

```text
http://localhost:5000
```

### Configure MLflow Client

In your Python scripts or notebooks:

```python
import mlflow

# Set the tracking URI
mlflow.set_tracking_uri("http://localhost:5000")

# Your MLflow code here
with mlflow.start_run():
    mlflow.log_param("param1", 5)
    mlflow.log_metric("metric1", 0.89)
```

### MinIO Console

Access the MinIO console at:

```text
http://localhost:9001
```

Login with the credentials specified in `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`.

## Features

- **Experiment Tracking**: Track ML experiments with parameters, metrics, and artifacts
- **Model Registry**: Version and manage ML models
- **Projects**: Package ML code in a reusable format
- **Models**: Deploy ML models to various platforms
- **Persistent Storage**: PostgreSQL for metadata, MinIO for artifacts

## Notes

- The `minio-init` service runs once to create the bucket and then stops.
- For production use, change all default passwords.
- Consider using external PostgreSQL and S3-compatible storage for production.
- The setup uses named volumes for data persistence.

## License

MLflow is licensed under the Apache License 2.0.
