# Redis

## Environment Variables

| Variable Name       | Description                                              | Default Value        |
| ------------------- | -------------------------------------------------------- | -------------------- |
| REDIS_VERSION       | Redis image version                                      | `"8.2.1-alpine3.22"` |
| SKIP_FIX_PERMS      | Skip permission fixing, set to 1 to skip                 | `""`                 |
| REDIS_PASSWORD      | Password for the default "default" user                  | `""`                 |
| REDIS_PORT_OVERRIDE | Host port mapping (maps to Redis port 6379 in container) | 6379                 |

Please modify the `.env` file as needed for your use case.
