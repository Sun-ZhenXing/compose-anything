# Portainer

[English](./README.md) | [中文](./README.zh.md)

This service deploys Portainer CE (Community Edition), a lightweight management UI for Docker and Docker Swarm.

## Services

- `portainer`: The Portainer CE service.

## Environment Variables

| Variable Name                | Description                                                       | Default Value   |
| ---------------------------- | ----------------------------------------------------------------- | --------------- |
| PORTAINER_VERSION            | Portainer image version                                           | `2.27.3-alpine` |
| PORTAINER_WEB_PORT_OVERRIDE  | Host port mapping for Web UI (maps to port 9000 in container)     | 9000            |
| PORTAINER_EDGE_PORT_OVERRIDE | Host port mapping for Edge Agent (maps to port 8000 in container) | 8000            |
| TZ                           | Timezone setting                                                  | `UTC`           |

Please modify the `.env` file as needed for your use case.

## Volumes

- `portainer_data`: A named volume for storing Portainer data.
- `/var/run/docker.sock`: Docker socket (required for Portainer to manage Docker).

## Ports

- `9000`: Portainer Web UI
- `8000`: Portainer Edge Agent

## Security Notes

⚠️ **Warning**: This service mounts the Docker socket (`/var/run/docker.sock`), which grants full control over the Docker daemon. This is required for Portainer to function properly, but it means:

- Any compromise of the Portainer container could lead to full system compromise
- Ensure Portainer is properly secured with strong passwords
- Consider restricting network access to the Portainer UI
- Keep Portainer updated to the latest version

## First-Time Setup

1. After starting the service, access Portainer at `http://localhost:9000`
2. Create an admin user account (this is required on first launch)
3. Choose to manage the local Docker environment
4. You can now manage your Docker containers, images, networks, and volumes through the UI

## Additional Information

- Official Documentation: <https://docs.portainer.io/>
- GitHub Repository: <https://github.com/portainer/portainer>
