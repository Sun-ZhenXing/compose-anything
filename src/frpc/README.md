# FRPC (Intranet Penetration Client)

[English](./README.md) | [中文](./README.zh.md)

This is an FRPC (Intranet Penetration Client) service.

## Example

Taking SSH service penetration as an example, create a new `frpc.toml` configuration file with the following content:

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "app_22"
type = "tcp"
remotePort = 23922
localIP = "192.168.10.100"
localPort = 22
```

Configure the remote FRPS service address in the `.env` file:

```properties
FRP_SERVER_ADDR=frps.example.com
FRP_SERVER_PORT=9870
FRP_SERVER_TOKEN=password
```

Start the service to proxy `192.168.10.100:22` to `FRP_SERVER_ADDR:23922`.

```bash
docker compose up -d
```

## Services

- `frpc`: The FRPC client service.

## Configuration

- `FRPC_VERSION`: The version of the FRPC image, default is `0.64.0`.
- `FRP_SERVER_ADDR`: The remote FRPS server address.
- `FRP_SERVER_PORT`: The remote FRPS server port.
- `FRP_SERVER_TOKEN`: The token for connecting to FRPS.

## Volumes

- `frpc.toml`: The configuration file for FRPC.
