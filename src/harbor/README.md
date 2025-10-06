# Harbor

[Harbor](https://goharbor.io/) is an open source registry that secures artifacts with policies and role-based access control, ensures images are scanned and free from vulnerabilities, and signs images as trusted.

## Features

- Security and Vulnerability Analysis: Scan images for vulnerabilities
- Content Trust: Sign and verify images
- Policy-based Replication: Replicate images across registries
- Role-based Access Control: Fine-grained access control
- Webhook Notifications: Notify external services on events
- Multi-tenancy: Support for multiple projects

## Quick Start

Start Harbor:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `HARBOR_VERSION`: Harbor version (default: `v2.12.0`)
- `HARBOR_HTTP_PORT_OVERRIDE`: HTTP port (default: `80`)
- `HARBOR_HTTPS_PORT_OVERRIDE`: HTTPS port (default: `443`)
- `HARBOR_ADMIN_PASSWORD`: Admin password (default: `Harbor12345`)
- `HARBOR_DB_PASSWORD`: Database password (default: `password`)
- `HARBOR_CORE_SECRET`: Core service secret
- `HARBOR_JOBSERVICE_SECRET`: Job service secret
- `HARBOR_REGISTRY_SECRET`: Registry HTTP secret
- `HARBOR_RELOAD_KEY`: Configuration reload key

## Access

- Web UI: <http://localhost>
- Docker Registry: <http://localhost>

Default credentials:

- Username: `admin`
- Password: `Harbor12345` (or value of `HARBOR_ADMIN_PASSWORD`)

## Usage

### Login to Harbor

```bash
docker login localhost
```

### Push an Image

```bash
docker tag myimage:latest localhost/myproject/myimage:latest
docker push localhost/myproject/myimage:latest
```

### Pull an Image

```bash
docker pull localhost/myproject/myimage:latest
```

## Important Notes

⚠️ **Security Warning**:

- Change the default admin password immediately after first login
- Set secure values for all secret environment variables
- Use HTTPS in production environments

## Components

- **harbor-core**: Core API server
- **harbor-portal**: Web UI
- **harbor-jobservice**: Background job service
- **harbor-registry**: Docker registry
- **harbor-db**: PostgreSQL database
- **harbor-redis**: Redis cache
- **harbor-proxy**: Nginx reverse proxy

## Resources

- Core: 1 CPU, 2G RAM
- JobService: 0.5 CPU, 512M RAM
- Registry: 0.5 CPU, 512M RAM
- Database: 1 CPU, 1G RAM
- Redis: 0.5 CPU, 256M RAM
