# Verdaccio

[English](./README.md) | [中文](./README.zh.md)

This service deploys Verdaccio, a lightweight private npm registry proxy.

## Services

- `verdaccio`: The Verdaccio service.

## Environment Variables

| Variable Name           | Description                                                  | Default Value |
| ----------------------- | ------------------------------------------------------------ | ------------- |
| VERDACCIO_VERSION       | Verdaccio image version                                      | `6.1.2`       |
| VERDACCIO_PORT          | Verdaccio container internal port                            | 4873          |
| VERDACCIO_PORT_OVERRIDE | Host port mapping (maps to Verdaccio port 4873 in container) | 4873          |
| TZ                      | Timezone setting                                             | `UTC`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `./storage`: Directory for storing published packages
- `./config`: Directory for Verdaccio configuration files
- `./plugins`: Directory for Verdaccio plugins

## Ports

- `4873`: Verdaccio Web UI and npm registry API

## First-Time Setup

1. After starting the service, access Verdaccio at `http://localhost:4873`
2. Create a user account:

   ```bash
   npm adduser --registry http://localhost:4873
   ```

3. Configure npm to use your Verdaccio registry:

   ```bash
   npm set registry http://localhost:4873
   ```

## Usage

### Publish a Package

```bash
npm publish --registry http://localhost:4873
```

### Install Packages

```bash
npm install <package-name> --registry http://localhost:4873
```

### Use as an Upstream Proxy

Verdaccio can proxy requests to the public npm registry. Packages not found locally will be fetched from npmjs.org and cached.

## Configuration

Edit the configuration file in `./config/config.yaml` to customize Verdaccio behavior:

- Authentication settings
- Package access control
- Upstream npm registry settings
- Web UI customization

## Additional Information

- Official Documentation: <https://verdaccio.org/docs/what-is-verdaccio>
- GitHub Repository: <https://github.com/verdaccio/verdaccio>
