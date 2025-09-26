# Clash

[English](./README.md) | [中文](./README.zh.md)

Clash is a rule-based tunnel in Go.

## Initialization

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Create your Clash configuration file `config.yaml` in the same directory.

3. Start the service:

   ```bash
   docker compose up -d
   ```

## Services

- `clash`: The Clash service.

## Configuration

- **Web Dashboard**: <http://localhost:7880>
- **SOCKS5 Proxy**: localhost:7890
- **HTTP Proxy**: localhost:7890

| Variable        | Description   | Default  |
| --------------- | ------------- | -------- |
| `CLASH_VERSION` | Clash version | `1.18.0` |

## Security Notes

- Change default passwords and configurations before production use
- Consider restricting access to the web dashboard
- Review your proxy rules and configurations

## License

Please refer to the official Clash project for license information.
