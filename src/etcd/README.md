# etcd

[English](./README.md) | [中文](./README.zh.md)

This service deploys etcd, a distributed, reliable key-value store for the most critical data of a distributed system.

## Services

- `etcd`: The etcd key-value store service.

## Environment Variables

| Variable Name                  | Description                                     | Default Value                     |
| ------------------------------ | ----------------------------------------------- | --------------------------------- |
| ETCD_VERSION                   | etcd image version                              | `v3.6.0`                          |
| ETCD_CLIENT_PORT_OVERRIDE      | Host port mapping for client connections (2379) | `2379`                            |
| ETCD_PEER_PORT_OVERRIDE        | Host port mapping for peer connections (2380)   | `2380`                            |
| ETCD_NAME                      | Human-readable name for this etcd member        | `etcd-node`                       |
| ETCD_INITIAL_CLUSTER           | Initial cluster configuration                   | `etcd-node=http://localhost:2380` |
| ETCD_INITIAL_CLUSTER_STATE     | Initial cluster state ('new' or 'existing')     | `new`                             |
| ETCD_INITIAL_CLUSTER_TOKEN     | Initial cluster token for bootstrap             | `etcd-cluster`                    |
| ETCD_AUTO_COMPACTION_RETENTION | Auto compaction retention in hours              | `1`                               |
| ETCD_QUOTA_BACKEND_BYTES       | Storage size limit in bytes                     | `2147483648` (2GB)                |
| ETCD_HEARTBEAT_INTERVAL        | Heartbeat interval in milliseconds              | `100`                             |
| ETCD_ELECTION_TIMEOUT          | Election timeout in milliseconds                | `1000`                            |
| ETCD_ENABLE_V2                 | Enable etcd v2 API                              | `false`                           |

Please modify the `.env` file as needed for your use case.

## Volumes

- `etcd_data`: A volume for storing etcd data persistently.

## Network Ports

- `2379`: Client communication port
- `2380`: Peer communication port (for clustering)

## Single Node Setup

The default configuration runs etcd as a single node, suitable for development and testing.

## Cluster Setup

To set up a multi-node etcd cluster, you need to:

1. Define multiple etcd services in your compose file
2. Configure the `ETCD_INITIAL_CLUSTER` variable properly
3. Set unique names for each node

Example for a 3-node cluster:

```yaml
services:
  etcd1:
    # ... base config
    environment:
      - ETCD_NAME=etcd1
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd1:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd1:2380

  etcd2:
    # ... base config
    environment:
      - ETCD_NAME=etcd2
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd2:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd2:2380

  etcd3:
    # ... base config
    environment:
      - ETCD_NAME=etcd3
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd3:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd3:2380
```

## Client Access

### Using etcdctl

Connect to etcd using the etcdctl client:

```bash
# Set endpoint
export ETCDCTL_ENDPOINTS=http://localhost:2379

# Put a key-value pair
etcdctl put mykey myvalue

# Get a value
etcdctl get mykey

# List all keys
etcdctl get --prefix ""
```

### Using HTTP API

etcd provides a RESTful HTTP API:

```bash
# Put a key-value pair
curl -X PUT http://localhost:2379/v3/kv/put \
  -H 'Content-Type: application/json' \
  -d '{"key":"bXlrZXk=","value":"bXl2YWx1ZQ=="}'

# Get a value
curl -X POST http://localhost:2379/v3/kv/range \
  -H 'Content-Type: application/json' \
  -d '{"key":"bXlrZXk="}'
```

## Performance Tuning

- Adjust `ETCD_QUOTA_BACKEND_BYTES` based on your storage needs
- Tune `ETCD_HEARTBEAT_INTERVAL` and `ETCD_ELECTION_TIMEOUT` for your network latency
- Configure `ETCD_AUTO_COMPACTION_RETENTION` to manage data size

## Security Notes

- The default configuration is for development/testing only
- For production, enable TLS encryption and authentication
- Consider network security and firewall rules
- Regular backups are recommended

## Monitoring

etcd exposes metrics at `http://localhost:2379/metrics` in Prometheus format.

## License

etcd is licensed under the Apache 2.0 license.
