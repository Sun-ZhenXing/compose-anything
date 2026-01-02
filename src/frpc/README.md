# FRPC (FRP Client)

[English](./README.md) | [中文](./README.zh.md)

FRPC is a fast reverse proxy client that connects to an FRP server to expose local services to the internet. This is the client component of the FRP (Fast Reverse Proxy) tool.

## Quick Start

1. Create a `.env` file from `.env.example`:

    ```bash
    cp .env.example .env
    ```

2. Edit the `.env` file and configure the FRP server connection:

    ```properties
    FRP_SERVER_ADDR=your.frp.server.com
    FRP_SERVER_PORT=7000
    FRP_SERVER_TOKEN=your_server_token
    ```

3. Create a `frpc.toml` configuration file with your proxy rules (see example below).

4. Start the service:

    ```bash
    docker compose up -d
    ```

## Configuration File

The client requires a `frpc.toml` file to define proxy rules. Here are some common examples:

### Example 1: SSH Service Proxy

Expose a local SSH service to the internet:

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "ssh"
type = "tcp"
remotePort = 6000
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 22
```

This configuration will:

- Connect to the FRP server at `FRP_SERVER_ADDR:FRP_SERVER_PORT`
- Expose local SSH (port 22) through the server's port 6000
- Access the service via `FRP_SERVER_ADDR:6000`

### Example 2: Web Service Proxy

Expose a local web application:

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "web"
type = "http"
customDomains = ["your-domain.com"]
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 8080
```

### Example 3: Multiple Services

Proxy multiple services simultaneously:

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "ssh"
type = "tcp"
remotePort = 6000
localIP = "192.168.1.100"
localPort = 22

[[proxies]]
name = "web"
type = "tcp"
remotePort = 8080
localIP = "192.168.1.101"
localPort = 80
```

### Example 4: Admin Dashboard

Enable the admin dashboard to monitor the client:

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

webServer.addr = "{{ .Envs.FRP_ADMIN_ADDR }}"
webServer.port = {{ .Envs.FRP_ADMIN_PORT }}
webServer.user = "{{ .Envs.FRP_ADMIN_USER }}"
webServer.password = "{{ .Envs.FRP_ADMIN_PASSWORD }}"

[[proxies]]
name = "app"
type = "tcp"
remotePort = 9000
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 3000
```

Access the admin dashboard at `http://localhost:7400` (default).

## Environment Variables

### Image Configuration

- `GLOBAL_REGISTRY`: Optional global registry prefix for pulling images
- `FRPC_VERSION`: FRPC image version (default: `0.65.0`)
- `TZ`: Timezone setting (default: `UTC`)

### Server Connection

- `FRP_SERVER_ADDR`: FRP server address (**required**, e.g., `frp.example.com` or `192.168.1.1`)
- `FRP_SERVER_PORT`: FRP server port (default: `7000`)
- `FRP_SERVER_TOKEN`: Authentication token for connecting to the server (**must match server token**)

### Local Application

- `FRP_APP_HOST`: Local application host address (default: `127.0.0.1`)
  - Use `host.docker.internal` to access services running on the host machine
  - Use specific IP addresses for services on your local network

### Admin Dashboard (Optional)

- `FRP_ADMIN_ADDR`: Admin dashboard bind address (default: `0.0.0.0`)
- `FRP_ADMIN_PORT`: Admin dashboard port (default: `7400`)
- `FRP_ADMIN_USER`: Admin dashboard username (default: `admin`)
- `FRP_ADMIN_PASSWORD`: Admin dashboard password (default: `password`)

### Resource Limits

- `FRPC_CPU_LIMIT`: CPU limit (default: `0.5`)
- `FRPC_MEMORY_LIMIT`: Memory limit (default: `128M`)
- `FRPC_CPU_RESERVATION`: CPU reservation (default: `0.1`)
- `FRPC_MEMORY_RESERVATION`: Memory reservation (default: `64M`)

## Volumes

- `./frpc.toml:/etc/frp/frpc.toml`: FRPC configuration file

## Accessing Host Services

To access services running on your host machine from within the container, use `host.docker.internal`:

```properties
FRP_APP_HOST=host.docker.internal
```

Then in your `frpc.toml`:

```toml
[[proxies]]
name = "local-service"
type = "tcp"
remotePort = 8080
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 3000
```

This will expose your host's port 3000 through the FRP server's port 8080.

## Security Notes

1. **Secure your token**: Keep your `FRP_SERVER_TOKEN` secret and use a strong, random value
2. **Limit exposure**: Only expose the services you actually need
3. **Use encryption**: Consider using HTTPS/TLS for sensitive services
4. **Monitor access**: Enable the admin dashboard to monitor active connections

## Troubleshooting

### Cannot connect to FRP server

- Verify `FRP_SERVER_ADDR` and `FRP_SERVER_PORT` are correct
- Ensure the FRP server is running and accessible
- Check that `FRP_SERVER_TOKEN` matches the server configuration

### Cannot access local service

- Verify `FRP_APP_HOST` is correct
- For host services, ensure you're using `host.docker.internal`
- For network services, ensure the IP address and port are correct
- Check firewall rules on both client and server sides

## License

FRP is licensed under the Apache License 2.0. See the [FRP GitHub repository](https://github.com/fatedier/frp) for more details.
