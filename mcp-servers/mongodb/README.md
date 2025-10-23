# MongoDB MCP Server

MongoDB MCP Server provides MongoDB database interaction capabilities through the Model Context Protocol, including data querying, insertion, updating, and collection management.

## Features

- 📊 **Database Operations** - CRUD operations support
- 🔍 **Query & Aggregation** - Complex queries and aggregation pipelines
- 📝 **Collection Management** - Create, delete, and modify collections
- 🔐 **Authentication** - Built-in authentication support
- � **Monitoring** - Health checks and resource monitoring
- 🌐 **RESTful API** - MCP protocol-based API interface

## Architecture

The service includes two containers:

- **mcp-mongodb**: MCP protocol adapter providing API interface
- **mongodb**: MongoDB database instance

## Environment Variables

| Variable                    | Default                   | Description                             |
| --------------------------- | ------------------------- | --------------------------------------- |
| `MCP_MONGODB_VERSION`       | `latest`                  | MCP MongoDB service version             |
| `MONGODB_VERSION`           | `7`                       | MongoDB version                         |
| `MCP_MONGODB_PORT_OVERRIDE` | `8000`                    | MCP service port                        |
| `MONGODB_PORT_OVERRIDE`     | `27017`                   | MongoDB port                            |
| `MONGODB_URI`               | `mongodb://mongodb:27017` | MongoDB connection URI                  |
| `MONGODB_DATABASE`          | `mcp_db`                  | Database name                           |
| `MONGO_ROOT_USERNAME`       | `admin`                   | Root username                           |
| `MONGO_ROOT_PASSWORD`       | `password`                | Root password (⚠️ change in production!) |
| `TZ`                        | `UTC`                     | Timezone                                |

## Quick Start

### 1. Configure Environment

Create a `.env` file:

```env
MCP_MONGODB_VERSION=latest
MONGODB_VERSION=7
MCP_MONGODB_PORT_OVERRIDE=8000
MONGODB_PORT_OVERRIDE=27017
MONGODB_DATABASE=mcp_db
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your_secure_password
TZ=Asia/Shanghai
```

### 2. Start Services

```bash
docker compose up -d
```

### 3. Verify Services

Check MCP service:

```bash
curl http://localhost:8000/health
```

Connect to MongoDB:

```bash
docker compose exec mongodb mongosh -u admin -p your_secure_password
```

## Resource Requirements

- **MCP Service**: 128MB-512MB memory, 0.25-1.0 CPU
- **MongoDB**: 512MB-2GB memory, 0.5-2.0 CPU

## Security Recommendations

1. **Change Default Password**: Always change `MONGO_ROOT_PASSWORD` in production
2. **Network Isolation**: Use internal networks, avoid exposing MongoDB port publicly
3. **Enable Authentication**: Ensure MongoDB authentication is enabled
4. **Regular Backups**: Set up regular data backup schedules

## Data Persistence

- `mongodb_data`: MongoDB data directory
- `mongodb_config`: MongoDB configuration directory

## Common Use Cases

1. **Application Backend** - As database backend for applications
2. **Data Analysis** - Store and query analysis data
3. **Document Storage** - Store and retrieve JSON documents
4. **Session Management** - Store user sessions

## References

- [MongoDB Official Documentation](https://docs.mongodb.com/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Docker Hub - mongo](https://hub.docker.com/_/mongo)

## License

MIT License
