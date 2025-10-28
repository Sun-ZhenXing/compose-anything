# OfficeConverter (JODConverter)

[English](./README.md) | [中文](./README.zh.md)

This service deploys OfficeConverter, a modern REST API for document conversion based on JODConverter and LibreOffice. It automates document conversions between various formats including Word, PDF, Excel, PowerPoint, and more. The officeconverter project is an extended and actively maintained version of jodconverter-samples-rest.

## Services

- `officeconverter`: The REST API service for document conversion with integrated LibreOffice instances.

## Environment Variables

| Variable Name                   | Description                              | Default Value |
| ------------------------------- | ---------------------------------------- | ------------- |
| OFFICECONVERTER_VERSION         | OfficeConverter image version            | `latest`      |
| OFFICECONVERTER_PORT_OVERRIDE   | Host port mapping (maps to port 8000)    | 8000          |
| CONVERTER_LIBREOFFICE_INSTANCES | Number of parallel LibreOffice instances | `2`           |
| CONVERTER_QUEUE_SIZE            | Maximum conversion queue size            | `1000`        |
| JAVA_OPTS                       | Java heap memory configuration           | `-Xmx1024m`   |
| TZ                              | Timezone                                 | `UTC`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `officeconverter_config`: A volume for storing OfficeConverter configuration at `/etc/app`.

## Usage

1. Start the service:

   ```bash
   docker compose up -d
   ```

2. The OfficeConverter REST API will be available at `http://localhost:8000` (or your configured port).

3. Check service readiness at `http://localhost:8000/ready`

## Document Conversion

### Basic Conversion

Convert a document using the REST API:

```bash
curl -X POST http://localhost:8000/conversion?format=pdf \
  -F "file=@input.docx" \
  -o output.pdf
```

### REST Endpoints

- `POST /conversion?format=<format>` - Convert a document to the specified format
  - Query parameter: `format` - Output format (e.g., pdf, html, docx, xlsx)
  - Form parameter: `file` - The file to convert
- `GET /ready` - Health check endpoint

### Supported Formats

OfficeConverter supports conversion between various document formats including:

- Documents: DOCX, DOC, ODT, RTF, TXT, DOTX
- Spreadsheets: XLSX, XLS, ODS, CSV, XLTX
- Presentations: PPTX, PPT, ODP
- PDF and HTML conversion

Additional formats can be added by editing `src/resources/document-formats.json`.

## Configuration

### LibreOffice Instances

Control the number of LibreOffice instances for parallel document processing:

```dotenv
CONVERTER_LIBREOFFICE_INSTANCES=4
```

More instances allow for greater concurrency but consume more memory.

### Memory Configuration

Adjust Java heap memory based on your conversion load:

```dotenv
JAVA_OPTS=-Xmx2048m
```

### Custom Configuration

Mount a custom `application.yml` file for advanced configuration:

```yaml
# /etc/app/application.yml
converter:
  libreoffice-instances: 4
  queue:
    max-size: 2000
```

## Resource Limits

- CPU: Limited to 2 cores with a reservation of 0.5 cores
- Memory: Limited to 2 GB with a reservation of 512 MB

The resource limits can be adjusted in docker-compose.yaml based on your conversion workload.

## Health Checks

The service includes a health check that verifies the `/ready` endpoint. The container will be considered healthy after 30 seconds of successful health checks.

## Advanced Usage

### Conversion with Options

Some conversions support additional parameters. Check the OfficeConverter documentation for advanced options.

### Monitoring

View logs to monitor conversion activity:

```bash
docker compose logs -f officeconverter
```

### Performance Tuning

For high-volume conversion workloads, consider:

- Increasing `CONVERTER_LIBREOFFICE_INSTANCES` to 4-8
- Increasing `JAVA_OPTS` memory limit
- Increasing `CONVERTER_QUEUE_SIZE` for more pending jobs

## Troubleshooting

### Service Not Ready

Check if the service is fully initialized:

```bash
curl http://localhost:8000/ready
```

If not ready, check the logs:

```bash
docker compose logs officeconverter
```

### Memory Issues

If conversions fail with memory errors, increase the Java heap:

```dotenv
JAVA_OPTS=-Xmx2048m
```

And increase the memory limit in docker-compose.yaml.

### Conversion Failures

Check service logs for detailed error messages:

```bash
docker compose logs officeconverter | grep -i error
```

For more information, visit the [OfficeConverter GitHub repository](https://github.com/EugenMayer/officeconverter).
