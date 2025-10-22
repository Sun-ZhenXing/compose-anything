# TiKV

TiKV 是一个开源、分布式、事务型键值数据库。它提供多种语言的 API，可以独立使用或与 TiDB 配合使用。

## 使用方法

```bash
docker compose up -d
```

## 组件说明

此配置包含：

- **PD (Placement Driver)**：管理和调度 TiKV 集群
- **TiKV**：分布式事务键值存储引擎

## 端口说明

- `2379`：PD 客户端端口
- `2380`：PD 对等端口
- `20160`：TiKV 服务端口
- `20180`：TiKV 状态和指标端口

## 访问方式

### 使用 TiKV 客户端

TiKV 提供多种语言的客户端库：

- [Rust 客户端](https://github.com/tikv/client-rust)
- [Go 客户端](https://github.com/tikv/client-go)
- [Java 客户端](https://github.com/tikv/client-java)
- [Python 客户端](https://github.com/tikv/client-py)

### 示例（使用 tikv-client-rust）

```rust
use tikv_client::{RawClient, Config};

#[tokio::main]
async fn main() {
    let client = RawClient::new(vec!["127.0.0.1:2379"], None)
        .await
        .unwrap();
    
    // 存储键值对
    client.put("key".to_owned(), "value".to_owned()).await.unwrap();
    
    // 获取值
    let value = client.get("key".to_owned()).await.unwrap();
    println!("Value: {:?}", value);
}
```

### 状态和指标

检查 TiKV 状态：

```bash
curl http://localhost:20180/status
```

获取 Prometheus 格式的指标：

```bash
curl http://localhost:20180/metrics
```

## 特性

- **分布式事务**：跨多个键的 ACID 事务
- **地理复制**：跨数据中心的数据复制
- **水平扩展**：通过添加更多 TiKV 节点扩展存储
- **一致性快照**：读取的快照隔离
- **云原生**：专为云环境设计

## 使用场景

- **键值存储**：独立的分布式键值数据库
- **与 TiDB 配合**：作为 TiDB 的存储层（参见 `tidb` 服务）
- **缓存后端**：具有持久化能力的分布式缓存
- **元数据存储**：为分布式系统存储元数据

## 注意事项

- 这是一个最小的单节点配置，适合开发环境
- 生产环境需要部署至少 3 个 TiKV 节点以实现数据复制
- 部署至少 3 个 PD 节点以实现高可用
- 使用 Prometheus 和 Grafana 进行监控
- 数据持久化在命名卷中

## 参考资料

- [TiKV 官方文档](https://tikv.org/docs/stable/)
- [TiKV 深入了解](https://tikv.org/deep-dive/)
- [TiKV Docker 镜像](https://hub.docker.com/r/pingcap/tikv)
- [TiKV 客户端](https://tikv.org/docs/stable/develop/clients/introduction/)
