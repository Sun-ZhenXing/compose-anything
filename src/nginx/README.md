# Nginx

[English](./README.md) | [中文](./README.zh.md)

This service deploys Nginx, a high-performance web server and reverse proxy server.

## Services

- `nginx`: The Nginx web server service.

## Environment Variables

| Variable Name             | Description                                    | Default Value       |
| ------------------------- | ---------------------------------------------- | ------------------- |
| NGINX_VERSION             | Nginx image version                            | `1.29.1-alpine3.20` |
| NGINX_HTTP_PORT_OVERRIDE  | Host port mapping for HTTP (maps to port 80)   | 80                  |
| NGINX_HTTPS_PORT_OVERRIDE | Host port mapping for HTTPS (maps to port 443) | 443                 |
| NGINX_HOST                | Server hostname for configuration              | `localhost`         |
| NGINX_PORT                | Server port for configuration                  | 80                  |

Please modify the `.env` file as needed for your use case.

## Volumes

- `nginx_logs`: A volume for storing Nginx logs.
- `./html`: Directory for web content (mounted as read-only).
- `./nginx.conf`: Optional custom Nginx configuration file.
- `./conf.d`: Optional directory for additional configuration files.
- `./ssl`: Optional SSL certificates directory.

## Usage

1. The `html` directory is already created with a default `index.html` file.

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access the web server at `http://localhost` (or your configured port).

## Configuration

- Custom Nginx configuration can be mounted at `/etc/nginx/nginx.conf`
- Additional server configurations can be placed in the `conf.d` directory
- SSL certificates can be mounted at `/etc/nginx/ssl/`
- Web content should be placed in the `html` directory

## Security Notes

- Consider using SSL/TLS certificates for production deployments
- Regularly update the Nginx version to get security patches
- Review and customize the Nginx configuration for your specific needs
