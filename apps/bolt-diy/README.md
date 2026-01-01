# Bolt.diy

Bolt.diy is an AI-powered web IDE that enables you to build full-stack web applications directly in your browser. It combines the power of AI with a modern development environment to streamline your development workflow.

## Quick Start

```bash
docker compose up -d
```

Access Bolt.diy at [http://localhost:5173](http://localhost:5173)

## Features

- **AI-Powered Development**: Leverage AI to assist with code generation and development
- **Full-Stack Development**: Build complete web applications with frontend and backend capabilities
- **Real-time Preview**: See your changes in real-time as you develop
- **Built-in Terminal**: Execute commands directly within the IDE
- **Git Integration**: Manage your repositories within the IDE

## Configuration

### Environment Variables

| Variable                       | Default | Description                                 |
| ------------------------------ | ------- | ------------------------------------------- |
| `BOLT_DIY_PORT_OVERRIDE`       | 5173    | Host port for accessing Bolt.diy            |
| `BOLT_DIY_VERSION`             | latest  | Docker image version                        |
| `VITE_LOG_LEVEL`               | info    | Log level (trace, debug, info, warn, error) |
| `ENABLE_EXPERIMENTAL_FEATURES` | false   | Enable experimental features                |
| `TZ`                           | UTC     | Timezone                                    |

### Port Mapping

- **5173**: Bolt.diy web interface

## Volume

The container uses in-memory storage for the development environment. For persistent storage, you can mount volumes as needed.

## Health Check

The service includes a health check that monitors the availability of the web interface.

## Resource Limits

- **CPU**: 2 cores (limit) / 0.5 cores (reservation)
- **Memory**: 2GB (limit) / 512MB (reservation)

## Documentation

- [Official Bolt.diy Repository](https://github.com/stackblitz-labs/bolt.diy)
- [Bolt.diy Documentation](https://docs.bolt.new/)

## License

Refer to the [Bolt.diy License](https://github.com/stackblitz-labs/bolt.diy/blob/main/LICENSE)
