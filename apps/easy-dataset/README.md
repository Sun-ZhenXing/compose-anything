# Easy Dataset

[English](./README.md) | [中文](./README.zh.md)

This service deploys Easy Dataset, a powerful tool for creating fine-tuning datasets for Large Language Models (LLMs). It provides an intuitive interface for uploading domain-specific files, intelligently splitting content, generating questions, and producing high-quality training data for model fine-tuning.

## Services

- `easy-dataset`: The main Easy Dataset application server with built-in SQLite database.

## Environment Variables

| Variable Name              | Description                         | Default Value |
| -------------------------- | ----------------------------------- | ------------- |
| EASY_DATASET_VERSION       | Easy Dataset image version          | `1.5.1`       |
| EASY_DATASET_PORT_OVERRIDE | Host port mapping for web interface | `1717`        |
| TZ                         | System timezone                     | `UTC`         |

Please create a `.env` file and modify it as needed for your use case.

## Volumes

- `easy_dataset_db`: A named volume for storing the SQLite database and uploaded files.
- `easy_dataset_prisma`: (Optional) A named volume for Prisma database files if needed.

## Getting Started

### Quick Start (Recommended)

1. (Optional) Create a `.env` file to customize settings:

   ```env
   EASY_DATASET_VERSION=1.5.1
   EASY_DATASET_PORT_OVERRIDE=1717
   TZ=Asia/Shanghai
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access Easy Dataset at `http://localhost:1717`

### With Prisma Database Mount (Advanced)

If you need to mount the Prisma database files:

1. Initialize the database first:

   ```bash
   # Clone the repository and initialize database
   git clone https://github.com/ConardLi/easy-dataset.git
   cd easy-dataset
   npm install
   npm run db:push
   ```

2. Uncomment the Prisma volume mount in `docker-compose.yaml`:

   ```yaml
   volumes:
     - easy_dataset_db:/app/local-db
     - easy_dataset_prisma:/app/prisma # Uncomment this line
   ```

3. Start the service:

   ```bash
   docker compose up -d
   ```

## Features

- **Intelligent Document Processing**: Supports PDF, Markdown, DOCX, and more
- **Smart Text Splitting**: Multiple algorithms with customizable segmentation
- **Question Generation**: Automatically extracts relevant questions from text
- **Domain Labels**: Builds global domain labels with understanding capabilities
- **Answer Generation**: Uses LLM APIs to generate comprehensive answers and Chain of Thought (COT)
- **Flexible Editing**: Edit questions, answers, and datasets at any stage
- **Multiple Export Formats**: Alpaca, ShareGPT, multilingual-thinking (JSON/JSONL)
- **Wide Model Support**: Compatible with all LLM APIs following OpenAI format

## Usage Workflow

1. **Create a Project**: Set up a new project with LLM API configuration
2. **Upload Documents**: Add your domain-specific files (PDF, Markdown, etc.)
3. **Text Splitting**: Review and adjust automatically split text segments
4. **Generate Questions**: Batch construct questions from text blocks
5. **Create Datasets**: Generate answers using configured LLM
6. **Export**: Export datasets in your preferred format

## Default Credentials

Easy Dataset does not require authentication by default. Access control should be implemented at the infrastructure level (e.g., reverse proxy, firewall rules).

## Resource Limits

The service is configured with the following resource limits:

- **CPU**: 0.5-2.0 cores
- **Memory**: 1-4 GB

These limits can be adjusted in `docker-compose.yaml` based on your workload requirements.

## Security Considerations

- **Data Privacy**: All data processing happens locally
- **API Keys**: Store LLM API keys securely within the application
- **Access Control**: Implement network-level access restrictions as needed
- **Updates**: Regularly update to the latest version for security patches

## Documentation

- Official Documentation: [https://docs.easy-dataset.com/](https://docs.easy-dataset.com/)
- GitHub Repository: [https://github.com/ConardLi/easy-dataset](https://github.com/ConardLi/easy-dataset)
- Video Tutorial: [Bilibili](https://www.bilibili.com/video/BV1y8QpYGE57/)
- Research Paper: [arXiv:2507.04009](https://arxiv.org/abs/2507.04009v1)

## Troubleshooting

### Container Won't Start

- Check logs: `docker compose logs easy-dataset`
- Verify port 1717 is not already in use
- Ensure sufficient system resources

### Database Issues

- For SQLite issues, remove and recreate the volume:

  ```bash
  docker compose down -v
  docker compose up -d
  ```

### Permission Errors

- Ensure the container has write access to mounted volumes
- Check Docker volume permissions

## License

Easy Dataset is licensed under AGPL 3.0. See the [LICENSE](https://github.com/ConardLi/easy-dataset/blob/main/LICENSE) file for details.

## Citation

If this work is helpful, please cite:

```bibtex
@misc{miao2025easydataset,
  title={Easy Dataset: A Unified and Extensible Framework for Synthesizing LLM Fine-Tuning Data from Unstructured Documents},
  author={Ziyang Miao and Qiyu Sun and Jingyuan Wang and Yuchen Gong and Yaowei Zheng and Shiqi Li and Richong Zhang},
  year={2025},
  eprint={2507.04009},
  archivePrefix={arXiv},
  primaryClass={cs.CL},
  url={https://arxiv.org/abs/2507.04009}
}
```
