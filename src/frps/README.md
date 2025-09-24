# FRPS (Intranet Penetration Server)

[English](./README.md) | [中文](./README.zh.md)

This is an FRPS (Intranet Penetration Server) service.

## Example

Create a new `frps.toml` configuration file with the following content:

```toml
bindPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

webServer.addr = "0.0.0.0"
webServer.port = {{ .Envs.FRP_ADMIN_PORT }}
webServer.user = "{{ .Envs.FRP_ADMIN_USER }}"
webServer.password = "{{ .Envs.FRP_ADMIN_PASS }}"
```

Configure secrets and other information in the `.env` file:

```properties
FRP_SERVER_TOKEN=token
FRP_ADMIN_USER=admin
FRP_ADMIN_PASS=password
```

Start the service to proxy client requests. Note that you need to map the client's port. You can share the service through HOST network or shared network.

To enable HOST mode, use the following method:

```yaml
services:
  frps:
    # ...
    network_mode: host
```

## Services

- `frps`: The FRPS server service.

## Configuration

- `FRPS_VERSION`: The version of the FRPS image, default is `0.64.0`.
- `FRP_SERVER_PORT`: The port for the FRPS server, default is `9870`.
- `FRP_ADMIN_PORT`: The port for the FRPS admin dashboard, default is `7890`.
- `FRP_PORT_OVERRIDE_SERVER`: The host port to map to the FRPS server port.
- `FRP_PORT_OVERRIDE_ADMIN`: The host port to map to the FRPS admin port.
- `FRP_SERVER_TOKEN`: The token for authenticating clients.
- `FRP_ADMIN_USER`: The username for the admin dashboard, default is `admin`.
- `FRP_ADMIN_PASS`: The password for the admin dashboard, default is `password`.

## Volumes

- `frps.toml`: The configuration file for FRPS.
