# LibreOffice

[English](./README.md) | [中文](./README.zh.md)

This service deploys LibreOffice, a free and open-source office suite. The linuxserver.io image provides a desktop GUI accessible through a web browser with HTTPS support.

## Services

- `libreoffice`: The LibreOffice desktop environment accessible via web browser.

## Environment Variables

| Variable Name                   | Description                                           | Default Value |
| ------------------------------- | ----------------------------------------------------- | ------------- |
| LIBREOFFICE_VERSION             | LibreOffice image version                             | `latest`      |
| LIBREOFFICE_HTTP_PORT_OVERRIDE  | Host port mapping for HTTP (maps to port 3000)        | 3000          |
| LIBREOFFICE_HTTPS_PORT_OVERRIDE | Host port mapping for HTTPS (maps to port 3001)       | 3001          |
| PUID                            | User ID for permission management                     | `1000`        |
| PGID                            | Group ID for permission management                    | `1000`        |
| CUSTOM_USER                     | Username for HTTP Basic Auth                          | `abc`         |
| PASSWORD                        | Password for HTTP Basic Auth (leave empty to disable) | (empty)       |
| TZ                              | Timezone                                              | `UTC`         |
| UMASK                           | Umask for file permissions                            | `022`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `libreoffice_config`: A volume for storing LibreOffice user home directory, program settings, and documents.

## Usage

1. Start the service:

   ```bash
   docker compose up -d
   ```

2. The service will be available at:
   - HTTP: `http://localhost:3000`
   - HTTPS: `https://localhost:3001`

3. Access the LibreOffice desktop through your web browser.

## Security

**HTTPS is required for full functionality.** Modern browser features such as WebCodecs used for video and audio will not function over an insecure HTTP connection.

### Authentication

By default, the container has no authentication. To enable HTTP Basic Auth:

1. Set the `PASSWORD` environment variable in your `.env` file
2. Optionally customize the `CUSTOM_USER` (default: `abc`)

For internet exposure, we strongly recommend placing the container behind a reverse proxy with robust authentication.

### Important Security Note

This container includes:

- Privileged access to system resources (due to GUI requirements)
- A terminal with passwordless `sudo` access within the container
- Any user with access to the GUI can gain root control within the container

**Do not expose this container to the Internet unless properly secured.**

## Configuration

- User and group IDs can be customized via `PUID` and `PGID` to match your host system
- Language support is available via `LC_ALL` environment variable (e.g., `LC_ALL=zh_CN.UTF-8` for Chinese)
- The `seccomp: unconfined` setting allows modern GUI applications to function on Docker

## Resource Limits

- CPU: Limited to 2 cores with a reservation of 0.5 cores
- Memory: Limited to 2 GB with a reservation of 512 MB

## Troubleshooting

If you encounter syscall-related errors, the `--security-opt seccomp=unconfined` setting (already included) should resolve them on older kernel versions.

For more information, visit the [linuxserver.io LibreOffice documentation](https://docs.linuxserver.io/images/docker-libreoffice/).
