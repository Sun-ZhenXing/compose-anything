# Docker Registry

[English](./README.md) | [中文](./README.zh.md)

This service sets up a private Docker registry.

## Prerequisites

1. Generate a TLS certificate for your server.
2. Place the certificate and key files (in PEM format) into the `certs/` directory.
3. Create a `.env` file and configure the following variables:

   ```bash
   REGISTRY_HTTP_TLS_CERTIFICATE=your_cert.crt
   REGISTRY_HTTP_TLS_KEY=your_key.key
   ```

## Services

- `registry`: The Docker registry service.

## Configuration

- `REGISTRY_VERSION`: The version of the registry image, default is `3.0.0`.
- `REGISTRY_PORT`: The port for the registry service, default is `5000`.
- `REGISTRY_AUTH`: The authentication method, default is `htpasswd`.
- `REGISTRY_AUTH_HTPASSWD_REALM`: The realm for htpasswd authentication, default is `Registry Realm`.
- `REGISTRY_AUTH_HTPASSWD_PATH`: The path to the htpasswd file, default is `/certs/passwd`.
- `REGISTRY_HTTP_TLS_CERTIFICATE`: The TLS certificate file.
- `REGISTRY_HTTP_TLS_KEY`: The TLS key file.
- `OTEL_TRACES_EXPORTER`: Set to `none` to disable tracing.

## Volumes

- `certs`: For storing TLS certificates.
- `config.yml`: The registry configuration file.
- `registry`: A volume for storing registry data.
