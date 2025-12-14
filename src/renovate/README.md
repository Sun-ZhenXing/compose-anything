# Renovate - Automated Dependency Updates

[中文文档](README.zh.md)

Renovate is an automated dependency update tool that keeps your project dependencies up-to-date by creating pull requests when new versions are available.

## Features

- 🤖 Automated dependency updates across multiple platforms
- 🔄 Support for GitHub, GitLab, Gitea, Bitbucket, Azure DevOps, and more
- 📦 Multi-language support: JavaScript, Python, Go, Docker, and many more
- 🎯 Highly configurable with smart defaults
- 🔒 Security-focused with vulnerability scanning
- 📊 Detailed update summaries and changelogs
- ⚙️ Flexible scheduling and auto-merge options

## Quick Start

1. **Copy the example environment file:**

   ```bash
   cp .env.example .env
   ```

2. **Configure authentication:**
   Edit `.env` and set:
   - `RENOVATE_PLATFORM`: Your platform (e.g., `github`, `gitlab`, `gitea`)
   - `RENOVATE_TOKEN`: Your authentication token (required)
   - `RENOVATE_REPOSITORIES`: Repositories to process (e.g., `myorg/repo1,myorg/repo2`)

3. **Get authentication token:**
   - **GitHub**: Create a Personal Access Token at <https://github.com/settings/tokens>
     - Required scopes: `repo`, `workflow`
   - **GitLab**: Create a Personal Access Token at <https://gitlab.com/-/profile/personal_access_tokens>
     - Required scopes: `api`, `write_repository`

4. **Run Renovate:**

   ```bash
   # One-time execution
   docker compose run --rm renovate

   # Or set up a cron job for periodic runs
   # Example: Run daily at 2 AM
   0 2 * * * cd /path/to/renovate && docker compose run --rm renovate
   ```

## Configuration

### Environment Variables

Key environment variables in `.env`:

| Variable                | Description             | Default        |
| ----------------------- | ----------------------- | -------------- |
| `RENOVATE_VERSION`      | Renovate image version  | `42.52.5-full` |
| `RENOVATE_PLATFORM`     | Platform type           | `github`       |
| `RENOVATE_TOKEN`        | Authentication token    | **(required)** |
| `RENOVATE_REPOSITORIES` | Repositories to process | `''`           |
| `RENOVATE_ONBOARDING`   | Create onboarding PR    | `true`         |
| `RENOVATE_DRY_RUN`      | Dry run mode            | `false`        |
| `RENOVATE_LOG_LEVEL`    | Log level               | `info`         |

### Advanced Configuration

For advanced configuration, edit `config.js`:

```javascript
module.exports = {
  platform: 'github',
  repositories: ['myorg/repo1', 'myorg/repo2'],
  
  // Schedule (cron format)
  schedule: ['before 5am on monday'],
  
  // Auto-merge settings
  automerge: true,
  automergeType: 'pr',
  
  // Package rules
  packageRules: [
    {
      matchUpdateTypes: ['minor', 'patch'],
      automerge: true,
    },
  ],
};
```

## Usage Examples

### Run on Specific Repositories

```bash
# Using environment variable
RENOVATE_REPOSITORIES=myorg/repo1,myorg/repo2 docker compose run --rm renovate

# Using config.js - edit the file first
docker compose run --rm renovate
```

### Dry Run Mode

Test configuration without creating actual PRs:

```bash
RENOVATE_DRY_RUN=full docker compose run --rm renovate
```

### Debug Mode

Enable detailed logging for troubleshooting:

```bash
RENOVATE_LOG_LEVEL=debug docker compose run --rm renovate
```

### Scheduled Execution

Create a systemd timer or cron job:

```bash
# Cron example (run daily at 2 AM)
0 2 * * * cd /path/to/renovate && docker compose run --rm renovate >> /var/log/renovate.log 2>&1
```

## How It Works

1. **Onboarding**: On first run, Renovate creates an onboarding PR with a `renovate.json` configuration file
2. **Scanning**: Renovate scans your repository for dependency files (package.json, requirements.txt, Dockerfile, etc.)
3. **Detection**: Checks for available updates across all detected dependencies
4. **PRs**: Creates pull requests for updates based on your configuration
5. **Scheduling**: Can be configured to run on a schedule (daily, weekly, etc.)

## Repository Configuration

After onboarding, configure Renovate behavior in your repository's `renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:base"],
  "schedule": ["after 10pm every weekday", "before 5am every weekday", "every weekend"],
  "packageRules": [
    {
      "matchUpdateTypes": ["minor", "patch"],
      "automerge": true
    }
  ]
}
```

## Supported Platforms

- GitHub (github.com and Enterprise Server)
- GitLab (gitlab.com and Self-Managed)
- Gitea
- Bitbucket Cloud and Server
- Azure DevOps
- And more...

## Supported Languages & Managers

Renovate supports 100+ package managers including:

- **JavaScript/Node.js**: npm, yarn, pnpm
- **Python**: pip, poetry, pipenv
- **Go**: go modules
- **Java**: maven, gradle
- **PHP**: composer
- **Ruby**: bundler
- **Rust**: cargo
- **Docker**: Dockerfile, docker-compose
- And many more...

## Security

- Runs as non-root user (configurable via `PUID`/`PGID`)
- Minimal capabilities with security hardening
- Token-based authentication (never expose tokens in logs)
- Support for vulnerability scanning and security updates

## Resources

Resource limits can be adjusted in `.env`:

- **CPU**: 2.0 cores limit, 0.5 cores reserved
- **Memory**: 2GB limit, 512MB reserved

## Troubleshooting

### No repositories found

Ensure `RENOVATE_TOKEN` has proper permissions and `RENOVATE_REPOSITORIES` is set correctly.

### Authentication errors

Verify token scopes:

- GitHub: `repo`, `workflow`
- GitLab: `api`, `write_repository`

### Rate limiting

Configure rate limits in `config.js`:

```javascript
prConcurrentLimit: 10,
prHourlyLimit: 2,
```

## Documentation

- Official Documentation: <https://docs.renovatebot.com/>
- Configuration Options: <https://docs.renovatebot.com/configuration-options/>
- GitHub Repository: <https://github.com/renovatebot/renovate>

## License

Renovate is licensed under the AGPL-3.0 license. See the [Renovate repository](https://github.com/renovatebot/renovate) for details.

## Notes

- Renovate is designed to run as a scheduled job, not a continuous service
- First run will create an onboarding PR in each repository
- Consider setting up a cron job or CI/CD pipeline for regular execution
- Monitor logs to ensure updates are being processed correctly
