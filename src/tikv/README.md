# TiKV

TiKV is an open-source, distributed, transactional key-value database. It provides APIs in multiple languages and is designed to complement or work independently of TiDB.

## Usage

```bash
docker compose up -d
```

## Components

This setup includes:

- **PD (Placement Driver)**: Manages and schedules TiKV clusters
- **TiKV**: Distributed transactional key-value storage engine

## Ports

- `2379`: PD client port
- `2380`: PD peer port
- `20160`: TiKV service port
- `20180`: TiKV status and metrics port

## Access

### Using TiKV Client

TiKV provides client libraries for multiple languages:

- [Rust Client](https://github.com/tikv/client-rust)
- [Go Client](https://github.com/tikv/client-go)
- [Java Client](https://github.com/tikv/client-java)
- [Python Client](https://github.com/tikv/client-py)

### Example (using tikv-client-rust)

```rust
use tikv_client::{RawClient, Config};

#[tokio::main]
async fn main() {
    let client = RawClient::new(vec!["127.0.0.1:2379"], None)
        .await
        .unwrap();
    
    // Put a key-value pair
    client.put("key".to_owned(), "value".to_owned()).await.unwrap();
    
    // Get the value
    let value = client.get("key".to_owned()).await.unwrap();
    println!("Value: {:?}", value);
}
```

### Status and Metrics

Check TiKV status:

```bash
curl http://localhost:20180/status
```

Get metrics in Prometheus format:

```bash
curl http://localhost:20180/metrics
```

## Features

- **Distributed Transactions**: ACID transactions across multiple keys
- **Geo-Replication**: Data replication across data centers
- **Horizontal Scalability**: Scale storage by adding more TiKV nodes
- **Consistent Snapshot**: Snapshot isolation for reads
- **Cloud Native**: Designed for cloud environments

## Use Cases

- **As a key-value store**: Standalone distributed key-value database
- **With TiDB**: Storage layer for TiDB (see `tidb` service)
- **Cache backend**: Distributed cache with persistence
- **Metadata store**: Store metadata for distributed systems

## Notes

- This is a minimal single-node setup for development
- For production, deploy at least 3 TiKV nodes for data replication
- Deploy at least 3 PD nodes for high availability
- Monitor using Prometheus and Grafana
- Data is persisted in named volumes

## References

- [TiKV Official Documentation](https://tikv.org/docs/stable/)
- [TiKV Deep Dive](https://tikv.org/deep-dive/)
- [TiKV Docker Images](https://hub.docker.com/r/pingcap/tikv)
- [TiKV Clients](https://tikv.org/docs/stable/develop/clients/introduction/)
