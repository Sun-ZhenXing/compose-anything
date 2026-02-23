# Jenkins

[English](./README.md) | [中文](./README.zh.md)

This service deploys Jenkins, an open-source automation server for CI/CD pipelines.

## Services

- `jenkins`: The Jenkins automation server.

## Environment Variables

| Variable Name               | Description                                       | Default Value                                   |
| --------------------------- | ------------------------------------------------- | ----------------------------------------------- |
| JENKINS_VERSION             | Jenkins image version                             | `2.486-lts-jdk17`                               |
| JENKINS_HTTP_PORT_OVERRIDE  | Host port mapping for HTTP (maps to port 8080)    | 8080                                            |
| JENKINS_AGENT_PORT_OVERRIDE | Host port mapping for agents (maps to port 50000) | 50000                                           |
| JENKINS_OPTS                | Additional Jenkins options                        | `--httpPort=8080`                               |
| JAVA_OPTS                   | Java JVM options                                  | `-Djenkins.install.runSetupWizard=false -Xmx2g` |
| CASC_JENKINS_CONFIG         | Configuration as Code directory                   | `/var/jenkins_home/casc_configs`                |
| JENKINS_USER_ID             | User ID for Jenkins process                       | 1000                                            |
| JENKINS_GROUP_ID            | Group ID for Jenkins process                      | 1000                                            |

Please modify the `.env` file as needed for your use case.

## Volumes

- `jenkins_home`: A volume for storing Jenkins data, configuration, and workspace.
- `/var/run/docker.sock`: Docker socket (read-only) for Docker-in-Docker functionality.
- `./jenkins.yaml`: Optional Configuration as Code file.

## Initial Setup

1. Start the service:

   ```bash
   docker compose up -d
   ```

2. Get the initial admin password:

   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```

3. Access Jenkins at `http://localhost:8080` and complete the setup wizard.

## Configuration as Code

Jenkins can be configured using Configuration as Code (JCasC). Create a `jenkins.yaml` file with your configuration and mount it to `/var/jenkins_home/casc_configs/jenkins.yaml`.

Example configuration:
```yaml
jenkins:
  systemMessage: Jenkins configured automatically by Jenkins Configuration as Code plugin

  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: admin
          password: admin123

  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
```

## Security Notes

- Change the default admin password immediately after setup
- Consider using HTTPS for production deployments
- Regularly update Jenkins and its plugins for security patches
- Use proper authentication and authorization strategies
- Restrict access to the Jenkins web interface
