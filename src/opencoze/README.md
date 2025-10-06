# OpenCoze

[English](./README.md) | [中文](./README.zh.md)

OpenCoze is a comprehensive AI application development platform based on Coze Studio.

## Important Notice

OpenCoze requires a complex multi-service architecture that includes:

- MySQL (database)
- Redis (caching)
- Elasticsearch (search engine)
- MinIO (object storage)
- etcd (distributed configuration)
- Milvus (vector database)
- NSQ (message queue)
- Coze Server (main application)
- Nginx (reverse proxy)

Due to the complexity of this setup, **we recommend using the official docker-compose configuration directly** from the Coze Studio repository.

## Official Deployment

1. Clone the official repository:

   ```bash
   git clone https://github.com/coze-dev/coze-studio.git
   cd coze-studio/docker
   ```

2. Follow the official deployment guide:
   - [Official Documentation](https://github.com/coze-dev/coze-studio)
   - [Docker Deployment Guide](https://github.com/coze-dev/coze-studio/tree/main/docker)

3. The official docker-compose includes all necessary services with proper configuration.

## System Requirements

- **Minimum Resources**:
  - CPU: 8 cores
  - RAM: 16GB
  - Disk: 100GB SSD

- **Recommended Resources**:
  - CPU: 16 cores
  - RAM: 32GB
  - Disk: 200GB SSD

## Key Features

- **AI Bot Builder**: Visual interface for creating AI-powered chatbots
- **Workflow Automation**: Design complex workflows with AI capabilities
- **Knowledge Base**: Manage and utilize knowledge bases for AI responses
- **Plugin System**: Extend functionality with custom plugins
- **Multi-model Support**: Integration with various LLM providers
- **Team Collaboration**: Multi-user workspace with permission management

## Getting Started

For detailed setup instructions, please refer to:

- [Official GitHub Repository](https://github.com/coze-dev/coze-studio)
- [Official Docker Compose](https://github.com/coze-dev/coze-studio/blob/main/docker/docker-compose.yml)

## Alternative: Cloud Version

If self-hosting is too complex, consider using the cloud version:

- [Coze Cloud](https://www.coze.com/) (Official cloud service)

## Security Notes

When deploying OpenCoze:

- Change all default passwords
- Use strong encryption keys
- Enable HTTPS with valid SSL certificates
- Implement proper firewall rules
- Regularly backup all data volumes
- Keep all services updated to the latest versions
- Monitor resource usage and performance

## Support

For issues and questions:

- [GitHub Issues](https://github.com/coze-dev/coze-studio/issues)
- [Official Documentation](https://github.com/coze-dev/coze-studio)
