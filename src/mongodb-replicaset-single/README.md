# MongoDB Single-Node Replica Set

[English](./README.md) | [中文](./README.zh.md)

This service sets up a single-node MongoDB replica set, ideal for development and testing environments.

## Prerequisites

1. Generate a key file for the replica set:

   ```bash
   mkdir -p ./secrets
   openssl rand -base64 756 > ./secrets/rs0.key
   ```

   On Windows, you can use Git Bash or WSL, or download the key file from the [MongoDB documentation](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/).

## Initialization

1. Start the services:

   ```bash
   docker compose up -d
   ```

   The services will automatically initialize the replica set through the `mongo-init` init container. This container:
   - Waits for the MongoDB node to be healthy
   - Connects to the node
   - Initializes the single-node replica set
   - Uses container-based networking for communication

2. Verify the replica set status:

   ```bash
   docker exec -it mongodb-replicaset-single-mongo1-1 mongosh -u root -p password --authenticationDatabase admin --eval "rs.status()"
   ```

## Services

- `mongo1`: The only member of the replica set.

## Configuration

- `TZ`: The timezone for the container, default is `UTC`.
- `MONGO_VERSION`: The version of the MongoDB image, default is `8.2.3`.
- `MONGO_INITDB_ROOT_USERNAME`: The root username for the database, default is `root`.
- `MONGO_INITDB_ROOT_PASSWORD`: The root password for the database, default is `password`.
- `MONGO_INITDB_DATABASE`: The initial database to create, default is `admin`.
- `MONGO_REPLICA_SET_NAME`: The name of the replica set, default is `rs0`.
- `MONGO_PORT_OVERRIDE_1`: The host port for the MongoDB node, default is `27017`.
- `MONGO_HOST`: The host name for the MongoDB node, default is `mongo1`.

## Volumes

- `mongo_data`: A named volume for MongoDB data persistence.
- `secrets/rs0.key`: The key file for authenticating members of the replica set.

## Security

The replica set key file is mounted read-only and copied to `/tmp` inside the container with proper permissions (400). This approach ensures cross-platform compatibility (Windows/Linux/macOS) while maintaining security requirements. The key file is never modified on the host system.

## Using the Single-Node Replica Set

You can connect to the MongoDB replica set using any MongoDB client:

```bash
mongosh "mongodb://root:password@localhost:27017/admin?authSource=admin&replicaSet=rs0"
```

Or using Python with PyMongo:

```python
from pymongo import MongoClient

client = MongoClient("mongodb://root:password@localhost:27017/admin?authSource=admin&replicaSet=rs0")
db = client.admin
print(db.command("ping"))
```
