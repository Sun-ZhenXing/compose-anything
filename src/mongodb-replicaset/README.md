# MongoDB Replica Set

[English](./README.md) | [中文](./README.zh.md)

This service sets up a MongoDB replica set with three members.

## Prerequisites

1. Generate a key file for the replica set:

   ```bash
   mkdir -p ./secrets
   openssl rand -base64 756 > ./secrets/rs0.key
   ```

## Initialization

1. Start the services:

   ```bash
   docker compose up -d
   ```

   The services will automatically initialize the replica set through the `mongo-init` init container. This container:
   - Waits for all MongoDB nodes to be healthy
   - Connects to the primary node
   - Initializes the replica set with internal container names
   - Uses container-based networking for communication

2. Verify the replica set status:

   ```bash
   docker exec -it mongodb-replicaset-mongo1-1 mongosh -u root -p password --authenticationDatabase admin --eval "rs.status()"
   ```

## Services

- `mongo1`: The first member of the replica set.
- `mongo2`: The second member of the replica set.
- `mongo3`: The third member of the replica set.

## Configuration

- `TZ`: The timezone for the container, default is `UTC`.
- `MONGO_VERSION`: The version of the MongoDB image, default is `8.2.3`.
- `MONGO_INITDB_ROOT_USERNAME`: The root username for the database, default is `root`.
- `MONGO_INITDB_ROOT_PASSWORD`: The root password for the database, default is `password`.
- `MONGO_INITDB_DATABASE`: The initial database to create, default is `admin`.
- `MONGO_REPLICA_SET_NAME`: The name of the replica set, default is `rs0`.
- `MONGO_PORT_OVERRIDE_1`: The host port for the first member, default is `27017`.
- `MONGO_PORT_OVERRIDE_2`: The host port for the second member, default is `27018`.
- `MONGO_PORT_OVERRIDE_3`: The host port for the third member, default is `27019`.

## Volumes

- `secrets/rs0.key`: The key file for authenticating members of the replica set.

## Security

The replica set key file is mounted read-only and copied to `/tmp` inside the container with proper permissions (400). This approach ensures cross-platform compatibility (Windows/Linux/macOS) while maintaining security requirements. The key file is never modified on the host system.
