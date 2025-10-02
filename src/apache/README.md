# Apache HTTP Server

[English](./README.md) | [中文](./README.zh.md)

This service deploys Apache HTTP Server, a popular open-source web server.

## Services

- `apache`: The Apache HTTP Server service.

## Environment Variables

| Variable Name              | Description                                    | Default Value       |
| -------------------------- | ---------------------------------------------- | ------------------- |
| APACHE_VERSION             | Apache HTTP Server image version               | `2.4.62-alpine3.20` |
| APACHE_HTTP_PORT_OVERRIDE  | Host port mapping for HTTP (maps to port 80)   | 80                  |
| APACHE_HTTPS_PORT_OVERRIDE | Host port mapping for HTTPS (maps to port 443) | 443                 |
| APACHE_RUN_USER            | User to run Apache as                          | `www-data`          |
| APACHE_RUN_GROUP           | Group to run Apache as                         | `www-data`          |

Please modify the `.env` file as needed for your use case.

## Volumes

- `apache_logs`: A volume for storing Apache logs.
- `./htdocs`: Directory for web content (mounted as read-only).
- `./httpd.conf`: Optional custom Apache configuration file.
- `./ssl`: Optional SSL certificates directory.

## Usage

1. Create the service directory structure:

   ```bash
   mkdir -p htdocs
   ```

2. Add your web content to the `htdocs` directory:

   ```bash
   echo "<h1>Hello World</h1>" > htdocs/index.html
   ```

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Access the web server at `http://localhost` (or your configured port).

## Configuration

- Custom Apache configuration can be mounted at `/usr/local/apache2/conf/httpd.conf`
- SSL certificates can be mounted at `/usr/local/apache2/conf/ssl/`
- Web content should be placed in the `htdocs` directory

## Security Notes

- The default configuration runs Apache as the `www-data` user for security
- Consider using SSL/TLS certificates for production deployments
- Regularly update the Apache version to get security patches
