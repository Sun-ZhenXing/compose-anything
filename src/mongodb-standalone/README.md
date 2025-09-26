# MongoDB Standalone

[English](./README.md) | [中文](./README.zh.md)

MongoDB is a document database designed for ease of application development and scaling.

## Initialization

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Connect to MongoDB at `mongodb://root:password@localhost:27017/admin`

## Services

- `mongo`: The MongoDB service.

## Configuration

- **Username**: `root`
- **Password**: `password`
- **Database**: `admin`
- **Port**: `27017`

| Variable                     | Description      | Default    |
| ---------------------------- | ---------------- | ---------- |
| `MONGO_VERSION`              | MongoDB version  | `8.0.13`   |
| `MONGO_INITDB_ROOT_USERNAME` | Root username    | `root`     |
| `MONGO_INITDB_ROOT_PASSWORD` | Root password    | `password` |
| `MONGO_INITDB_DATABASE`      | Initial database | `admin`    |
| `MONGO_PORT_OVERRIDE`        | Port override    | `27017`    |

## Volumes

- `mongo_data`: A volume for storing MongoDB data.

```bash
# Using mongo shell
mongo mongodb://root:password@localhost:27017/admin

# Using mongosh
mongosh "mongodb://root:password@localhost:27017/admin"
```

## Security Notes

- Change the default password before production use
- Consider using MongoDB authentication and authorization features
- Restrict network access as needed

## License

MongoDB is available under the Server Side Public License (SSPL).
