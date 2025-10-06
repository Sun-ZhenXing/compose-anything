# Dockge

[English](./README.md) | [中文](./README.zh.md)

This service deploys Dockge, a fancy, easy-to-use and reactive self-hosted docker compose stack-oriented manager.

## Services

- `dockge`: The Dockge web interface for managing Docker Compose stacks.

## Environment Variables

| Variable Name     | Description                           | Default Value |
| ----------------- | ------------------------------------- | ------------- |
| DOCKGE_VERSION    | Dockge image version                  | `1`           |
| PORT_OVERRIDE     | Host port mapping                     | `5001`        |
| STACKS_DIR        | Directory on host for storing stacks  | `./stacks`    |
| DOCKGE_STACKS_DIR | Directory inside container for stacks | `/opt/stacks` |
| PUID              | User ID to run the service            | `1000`        |
| PGID              | Group ID to run the service           | `1000`        |

Please modify the `.env` file as needed for your use case.

## Volumes

- `dockge_data`: A volume for storing Dockge application data.
- Docker socket: Mounted to allow Dockge to manage Docker containers.
- Stacks directory: Where your docker-compose.yaml files are stored.

## Features

- 🧑‍💼 Manage your `compose.yaml` files
- ⌨️ Interactive Editor for `compose.yaml`
- 🦦 Interactive Web Terminal
- 🏪 Convert `docker run ...` commands into `compose.yaml`
- 📙 File based structure - doesn't kidnap your compose files
- 🚄 Reactive - Everything is just responsive

## Security Notes

- Dockge requires access to the Docker socket, which grants it full control over Docker.
- Only run Dockge on trusted networks.
- Consider using authentication if exposing to the internet.
- The default setup stores data in a named volume for persistence.

## First Run

On first run, you will be prompted to create an admin account. Make sure to use a strong password.

## License

Dockge is licensed under the MIT License.
