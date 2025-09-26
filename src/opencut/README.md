# OpenCut

[English](./README.md) | [中文](./README.zh.md)

OpenCut is an open-source video editing and audio processing platform.

## Prerequisites

1. Visit [FreeSound.org](https://freesound.org/) and create an account
2. Create an API application in your account settings
3. Get your client ID and API key

## Initialization

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Configure the required environment variables (especially FreeSound API configuration)

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Access the web interface at <http://localhost:3100>

## Services

- `opencut`: The OpenCut web application.
- `postgres`: The PostgreSQL database.
- `redis`: The Redis cache.

## Configuration

- **Web Application**: Port 3100
- **PostgreSQL Database**: Port 5432
- **Redis Cache**: Port 6379
- **Redis HTTP Service**: Port 8079

| Variable                  | Description                     | Required |
| ------------------------- | ------------------------------- | -------- |
| `FREESOUND_CLIENT_ID`     | FreeSound client ID             | Yes      |
| `FREESOUND_API_KEY`       | FreeSound API key               | Yes      |
| `CLOUDFLARE_ACCOUNT_ID`   | Cloudflare account ID           | No*      |
| `R2_ACCESS_KEY_ID`        | R2 access key ID                | No*      |
| `R2_SECRET_ACCESS_KEY`    | R2 secret key                   | No*      |
| `R2_BUCKET_NAME`          | R2 bucket name                  | No*      |
| `MODAL_TRANSCRIPTION_URL` | Modal transcription service URL | No*      |

*Required for transcription features. Leave blank if auto-captioning is not needed.
4. Add these values to your `.env` file

## Data Persistence

- PostgreSQL data is stored in the `postgres_data` volume
- Redis data is in-memory and will be lost on restart

## Security Notes

- Change the default database password in production
- Update `BETTER_AUTH_SECRET` to a secure random string
- Consider setting up a reverse proxy for external access

## Reference

- [Original docker-compose.yaml](https://github.com/OpenCut-app/OpenCut/blob/main/docker-compose.yaml)

## License

Please refer to the official OpenCut project for license information.
