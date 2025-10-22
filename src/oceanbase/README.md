# OceanBase

OceanBase is a distributed relational database developed by Ant Group. It features high availability, high scalability, and is compatible with MySQL.

## Usage

```bash
docker compose up -d
```

## Configuration

Key environment variables:

- `OB_ROOT_PASSWORD`: Root user password (default: `oceanbase`)
- `OB_TENANT_NAME`: Tenant name (default: `test`)
- `OB_TENANT_PASSWORD`: Tenant password (default: `oceanbase`)
- `OB_MEMORY_LIMIT`: Memory limit (default: `8G`, minimum: `8G`)
- `OB_DATAFILE_SIZE`: Data file size (default: `10G`)
- `OB_LOG_DISK_SIZE`: Log disk size (default: `6G`)

## Ports

- `2881`: MySQL protocol port
- `2882`: RPC port

## Connection

Connect using MySQL client:

```bash
mysql -h127.0.0.1 -P2881 -uroot@test -poceanbase
```

Or connect to sys tenant:

```bash
mysql -h127.0.0.1 -P2881 -uroot -poceanbase
```

## Notes

- OceanBase requires at least 8GB of memory to run properly
- First startup may take several minutes to initialize
- Use `slim` mode for development/testing environments
- For production, consider using `normal` mode and a dedicated cluster

## References

- [OceanBase Official Documentation](https://www.oceanbase.com/docs)
- [OceanBase Docker Hub](https://hub.docker.com/r/oceanbase/oceanbase-ce)
