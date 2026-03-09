# Convex

Convex is an open-source reactive database designed to make life easy for web app developers, whether human or LLM.

## Features

- **Reactive Queries**: Queries automatically update when underlying data changes
- **Real-time Subscriptions**: Live UI updates without manual polling
- **Serverless Functions**: Write backend logic in TypeScript/JavaScript
- **Automatic Caching**: Built-in intelligent caching for optimal performance
- **Type Safety**: Full TypeScript support with generated types
- **Scalable Architecture**: Designed to handle high-throughput applications

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Generate an instance secret (required for production):

   ```bash
   openssl rand -hex 32
   ```

   Then set `INSTANCE_SECRET` in your `.env` file.

3. Start Convex:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be healthy (check with `docker compose ps`)

5. Access the Dashboard at `http://localhost:6791`

6. Backend API is available at `http://localhost:3210`

## Default Configuration

| Service        | Port | Description                     |
| -------------- | ---- | ------------------------------- |
| Convex Backend | 3210 | Main API and WebSocket endpoint |
| Site Proxy     | 3211 | Site hosting proxy              |
| Dashboard      | 6791 | Web UI for managing Convex      |
| PostgreSQL     | 5432 | Database (internal)             |

**Authentication**: Set `INSTANCE_SECRET` for production use.

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                          | Description                       | Default                 |
| --------------------------------- | --------------------------------- | ----------------------- |
| `CONVEX_BACKEND_PORT_OVERRIDE`    | Host port for backend API         | `3210`                  |
| `CONVEX_SITE_PROXY_PORT_OVERRIDE` | Host port for site proxy          | `3211`                  |
| `CONVEX_DASHBOARD_PORT_OVERRIDE`  | Host port for dashboard           | `6791`                  |
| `INSTANCE_NAME`                   | Name of the Convex instance       | `convex-self-hosted`    |
| `INSTANCE_SECRET`                 | Secret key for authentication     | (required)              |
| `CONVEX_CLOUD_ORIGIN`             | URL for backend access            | `http://127.0.0.1:3210` |
| `CONVEX_SITE_ORIGIN`              | URL for site proxy access         | `http://127.0.0.1:3211` |
| `POSTGRES_PASSWORD`               | PostgreSQL password               | `convex`                |
| `RUST_LOG`                        | Log level (error/warn/info/debug) | `info`                  |
| `TZ`                              | Timezone                          | `UTC`                   |

## Resource Requirements

**Minimum**:

- CPU: 1 core
- RAM: 1GB
- Disk: 5GB

**Recommended**:

- CPU: 2+ cores
- RAM: 2GB+
- Disk: 20GB+

## Volumes

- `convex_data`: Convex backend data storage
- `postgres_data`: PostgreSQL database data

## Using with Your Application

To use this self-hosted Convex backend with your application:

1. Set the `CONVEX_SELF_HOSTED_URL` environment variable in your app:

   ```bash
   CONVEX_SELF_HOSTED_URL=http://localhost:3210
   ```

2. Set the `CONVEX_SELF_HOSTED_ADMIN_KEY` environment variable:

   ```bash
   CONVEX_SELF_HOSTED_ADMIN_KEY=your-instance-secret
   ```

3. Deploy your Convex functions:

   ```bash
   npx convex dev
   ```

For more details, see the [Convex Self-Hosting Documentation](https://stack.convex.dev/self-hosted-develop-and-deploy).

## Security Notes

- **Always set a strong `INSTANCE_SECRET`** in production
- Enable SSL/TLS by setting `DO_NOT_REQUIRE_SSL=false` and using a reverse proxy
- Use strong database passwords
- Restrict network access to Convex services
- Consider using AWS S3 for external storage in production

## License

Apache-2.0 (<https://github.com/get-convex/convex-backend/blob/main/LICENSE>)
