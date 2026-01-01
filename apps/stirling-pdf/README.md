# Stirling-PDF

[English](./README.md) | [中文](./README.zh.md)

This service deploys Stirling-PDF, a locally hosted web-based PDF manipulation tool.

## Services

- `stirling-pdf`: The Stirling-PDF service.

## Environment Variables

| Variable Name        | Description                           | Default Value  |
| -------------------- | ------------------------------------- | -------------- |
| STIRLING_VERSION     | Stirling-PDF image version            | `latest`       |
| PORT_OVERRIDE        | Host port mapping                     | `8080`         |
| ENABLE_SECURITY      | Enable security features              | `false`        |
| ENABLE_LOGIN         | Enable login functionality            | `false`        |
| INITIAL_USERNAME     | Initial admin username                | `admin`        |
| INITIAL_PASSWORD     | Initial admin password                | `admin`        |
| INSTALL_ADVANCED_OPS | Install advanced operations           | `false`        |
| LANGUAGES            | Supported languages (comma-separated) | `en_GB`        |
| PUID                 | User ID to run the service            | `1000`         |
| PGID                 | Group ID to run the service           | `1000`         |
| UMASK                | File creation mask                    | `022`          |
| DEFAULT_LOCALE       | Default system locale                 | `en-US`        |
| APP_NAME             | Application name                      | `Stirling-PDF` |
| HOME_DESCRIPTION     | Home page description                 | `""`           |
| NAVBAR_NAME          | Navigation bar name                   | `""`           |
| MAX_FILE_SIZE        | Maximum file size in MB               | `2000`         |
| METRICS_ENABLED      | Enable metrics collection             | `false`        |
| GOOGLE_VISIBILITY    | Allow Google indexing                 | `false`        |

Please modify the `.env` file as needed for your use case.

## Volumes

- `stirling_trainingData`: OCR training data for Tesseract.
- `stirling_configs`: Configuration files.
- `stirling_logs`: Application logs.
- `stirling_customFiles`: Custom files and templates.

## Features

Stirling-PDF supports 50+ PDF operations including:

- Merge, split, rotate PDFs
- Convert to/from PDF
- OCR (Optical Character Recognition)
- Add/remove watermarks
- Compress PDFs
- Encrypt/decrypt PDFs
- Sign PDFs
- Fill forms
- Extract images and text
- And much more!

## Security Notes

- By default, security is disabled for easy setup.
- For production use, set `ENABLE_SECURITY=true` and `ENABLE_LOGIN=true`.
- Change the default admin credentials before deployment.
- Consider using a reverse proxy with HTTPS for secure access.

## License

Stirling-PDF is licensed under the MIT License.
