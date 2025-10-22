# Apache Flink

Apache Flink is a framework and distributed processing engine for stateful computations over unbounded and bounded data streams.

## Usage

```bash
docker compose up -d
```

## Components

This setup includes:

- **JobManager**: Coordinates Flink jobs and manages resources
- **TaskManager**: Executes tasks and manages data streams

## Configuration

Key environment variables in `FLINK_PROPERTIES`:

- `jobmanager.rpc.address`: JobManager RPC address
- `jobmanager.memory.process.size`: JobManager memory (default: 1600m)
- `taskmanager.memory.process.size`: TaskManager memory (default: 1600m)
- `taskmanager.numberOfTaskSlots`: Number of task slots per TaskManager (default: 2)

## Ports

- `6123`: JobManager RPC port
- `8081`: Flink Web UI

## Access

### Web UI

Access Flink Dashboard at: <http://localhost:8081>

### Submit Jobs

Submit a Flink job:

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/examples/streaming/WordCount.jar
```

Submit a custom job:

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/jobs/my-job.jar
```

### Job Management

```bash
# List running jobs
docker compose exec jobmanager ./bin/flink list

# Cancel a job
docker compose exec jobmanager ./bin/flink cancel <job-id>

# Show job details
docker compose exec jobmanager ./bin/flink info /path/to/job.jar
```

## Example: WordCount

Run the built-in WordCount example:

```bash
docker compose exec jobmanager ./bin/flink run /opt/flink/examples/streaming/WordCount.jar
```

## Scaling TaskManagers

To scale TaskManagers for more processing capacity:

```bash
docker compose up -d --scale taskmanager=3
```

## Custom Jobs

Mount your custom Flink jobs by uncommenting the volume in `docker-compose.yaml`:

```yaml
volumes:
  - ./jobs:/opt/flink/jobs
```

Then place your JAR files in the `./jobs` directory.

## Notes

- This is a standalone cluster setup suitable for development
- For production, consider using Flink on Kubernetes or YARN
- Adjust memory settings based on your workload requirements
- Task slots determine parallelism; more slots allow more parallel tasks
- Data is persisted in the named volume `flink_data`

## References

- [Apache Flink Official Documentation](https://flink.apache.org/docs/stable/)
- [Flink Docker Setup](https://nightlies.apache.org/flink/flink-docs-stable/docs/deployment/resource-providers/standalone/docker/)
- [Flink Docker Hub](https://hub.docker.com/_/flink)
