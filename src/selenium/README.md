# Selenium Standalone with Chrome

[![Docker Image](https://img.shields.io/docker/v/selenium/standalone-chrome?sort=semver)](https://hub.docker.com/r/selenium/standalone-chrome)
[![Docker Pulls](https://img.shields.io/docker/pulls/selenium/standalone-chrome)](https://hub.docker.com/r/selenium/standalone-chrome)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/LICENSE.md)

Selenium Grid in Standalone mode with Chrome browser for browser automation at scale.

## Quick Start

```bash
# Start the service
docker compose up -d

# Verify the service is running
docker compose ps

# View logs
docker compose logs -f

# Stop the service
docker compose down
```

## Service Information

### Ports

| Port | Service       | Description                                  |
| ---- | ------------- | -------------------------------------------- |
| 4444 | Selenium Grid | HTTP endpoint for WebDriver                  |
| 7900 | noVNC         | Browser viewing interface (password: secret) |

### Default Credentials

- VNC Password: `secret` (configurable via `SE_VNC_PASSWORD`)

### Volumes

- `selenium_downloads`: Browser downloads directory (`/home/seluser/Downloads`)

## Configuration

### Environment Variables

All configuration can be customized via the `.env` file:

```bash
# Copy the example configuration
cp .env.example .env

# Edit the configuration
nano .env
```

Key configurations:

| Variable                      | Default          | Description                                         |
| ----------------------------- | ---------------- | --------------------------------------------------- |
| `SELENIUM_VERSION`            | `144.0-20260120` | Docker image tag (Chrome version + date)            |
| `SELENIUM_SHM_SIZE`           | `2g`             | Shared memory size (required for browser stability) |
| `SELENIUM_GRID_PORT_OVERRIDE` | `4444`           | Grid HTTP endpoint port                             |
| `SELENIUM_VNC_PORT_OVERRIDE`  | `7900`           | noVNC viewer port                                   |
| `SE_SCREEN_WIDTH`             | `1920`           | Browser screen width                                |
| `SE_SCREEN_HEIGHT`            | `1080`           | Browser screen height                               |
| `SE_NODE_MAX_SESSIONS`        | `1`              | Max concurrent sessions per container               |
| `SE_NODE_SESSION_TIMEOUT`     | `300`            | Session timeout in seconds                          |

For a complete list of environment variables, see the [Selenium Docker documentation](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/ENV_VARIABLES.md).

## Usage

### Basic WebDriver Test (Python)

```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# Configure Chrome options
options = Options()

# Connect to Selenium Grid
driver = webdriver.Remote(
    command_executor='http://localhost:4444',
    options=options
)

# Run your test
driver.get('https://www.selenium.dev/')
print(driver.title)

# Clean up
driver.quit()
```

### Basic WebDriver Test (Node.js)

```javascript
const { Builder } = require('selenium-webdriver')
const chrome = require('selenium-webdriver/chrome');

(async function example() {
  const driver = await new Builder()
    .forBrowser('chrome')
    .usingServer('http://localhost:4444')
    .build()

  try {
    await driver.get('https://www.selenium.dev/')
    console.log(await driver.getTitle())
  }
  finally {
    await driver.quit()
  }
})()
```

### Viewing Browser Sessions

You can watch tests execute in real-time using noVNC:

1. Open your browser to `http://localhost:7900/?autoconnect=1&resize=scale&password=secret`
2. The default VNC password is `secret`
3. You'll see the browser session in real-time

Alternatively, use a VNC client to connect to `localhost:5900` (if exposed).

## Advanced Configuration

### Changing Browser Version

To use a specific Chrome version, update the `SELENIUM_VERSION` in your `.env` file:

```bash
# Use Chrome 143.0
SELENIUM_VERSION=143.0-20260120

# Or use a specific Selenium Grid version
SELENIUM_VERSION=144.0-chromedriver-144.0-grid-4.40.0-20260120
```

Visit [Docker Hub](https://hub.docker.com/r/selenium/standalone-chrome/tags) for available versions.

### Increasing Concurrent Sessions

To run multiple concurrent sessions in one container (not recommended for production):

```bash
SE_NODE_MAX_SESSIONS=5
```

**Note:** For better stability, scale containers instead:

```bash
docker compose up -d --scale selenium-chrome=3
```

### Retrieving Downloaded Files

To access files downloaded during tests, mount the downloads directory:

```yaml
volumes:
  - ./downloads:/home/seluser/Downloads
```

**Linux users:** Set proper permissions before mounting:

```bash
mkdir -p ./downloads
sudo chown 1200:1201 ./downloads
```

### Running in Headless Mode

For newer Chrome versions (127+), headless mode requires Xvfb:

```bash
SE_START_XVFB=true
```

Then configure headless in your test:

```python
options = Options()
options.add_argument('--headless=new')
```

### Custom Screen Resolution

Adjust screen resolution for your test needs:

```bash
SE_SCREEN_WIDTH=1366
SE_SCREEN_HEIGHT=768
SE_SCREEN_DEPTH=24
SE_SCREEN_DPI=74
```

## Health Check

The container includes a built-in health check that polls the Grid status endpoint every 30 seconds:

```bash
# Check container health
docker compose ps

# Or inspect the health status
docker inspect --format='{{json .State.Health.Status}}' <container-id>
```

## Troubleshooting

### Browser Crashes

If you see errors like "Chrome failed to start" or "invalid argument: can't kill an exited process":

1. **Ensure sufficient shared memory:** The default `2g` should work for most cases

   ```bash
   SELENIUM_SHM_SIZE=2g
   ```

2. **Check headless mode configuration:** Make sure `SE_START_XVFB=true` if using headless mode with Chrome 127+

### Permission Issues (Linux)

When mounting volumes on Linux, ensure correct permissions:

```bash
# For downloads directory
mkdir -p ./downloads
sudo chown 1200:1201 ./downloads

# Check user/group IDs in container
docker compose exec selenium-chrome id
```

### Resource Constraints

If tests are slow or containers are being OOM killed:

```bash
# Increase resource limits
SELENIUM_CPU_LIMIT=4.0
SELENIUM_MEMORY_LIMIT=4G
```

### VNC Connection Issues

If you can't connect to VNC:

1. Check that port 7900 is not in use
2. Verify the VNC password is correct (default: `secret`)
3. Try disabling VNC authentication: `SE_VNC_NO_PASSWORD=true`

## Multi-Browser Support

For running multiple browser types (Chrome, Firefox, Edge), consider using:

- **Hub & Nodes architecture:** See `docker-compose-grid.yaml` example
- **Dynamic Grid:** Automatically spawns containers on demand
- **Selenium Grid 4:** Full distributed mode with Router, Distributor, etc.

## Additional Resources

- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Docker Selenium GitHub](https://github.com/SeleniumHQ/docker-selenium)
- [Selenium Grid Configuration](https://www.selenium.dev/documentation/grid/)
- [Environment Variables Reference](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/ENV_VARIABLES.md)

## Security Notes

- **VNC Password:** Change the default `secret` password in production
- **Network Exposure:** Do not expose Selenium Grid directly to the internet
- **Resource Limits:** Always set CPU and memory limits to prevent resource exhaustion
- **User Permissions:** Selenium runs as non-root user `seluser` (UID 1200, GID 1201)

## License

This configuration is provided under the Apache License 2.0, following the Selenium project's licensing.
The Selenium Docker images are maintained by the SeleniumHQ team and community contributors.
