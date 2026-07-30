# Open Policy Agent (OPA)

[English](./README.md) | [中文](./README.zh.md)

Open Policy Agent (OPA) is a general-purpose policy engine for making policy decisions from structured data. This Compose stack runs the official OPA image with a minimal authorization policy.

## Services

- `opa`: OPA policy server and HTTP API on container port 8181

## Quick Start

```bash
docker compose up -d
```

OPA is available at <http://127.0.0.1:8181> by default.

Evaluate the included policy for the allowed user `alice`:

```bash
curl --request POST http://127.0.0.1:8181/v1/data/app/authz/allow \
  --header "Content-Type: application/json" \
  --data '{"input":{"user":"alice"}}'
```

The response is `{"result":true}`.

## Configuration and Policy Files

- [policies/authz.rego](./policies/authz.rego) defines a default-deny authorization rule and permits users listed in policy data.
- [policies/data.json](./policies/data.json) contains the allowed users and initially permits `alice`.

Edit these local files and restart OPA to load policy changes:

```bash
docker compose restart opa
```

## Environment Variables

| Variable | Description | Default |
| --- | --- | --- |
| `GLOBAL_REGISTRY` | Optional global registry prefix | `""` |
| `OPA_VERSION` | OPA image version | `1.18.2` |
| `TZ` | Container timezone | `UTC` |
| `OPA_PORT_OVERRIDE` | Loopback host port mapped to container port 8181 | `8181` |
| `OPA_CPU_LIMIT` | CPU limit | `0.5` |
| `OPA_CPU_RESERVATION` | CPU reservation | `0.1` |
| `OPA_MEMORY_LIMIT` | Memory limit | `256M` |
| `OPA_MEMORY_RESERVATION` | Memory reservation | `128M` |

## Ports

- `127.0.0.1:8181`: OPA HTTP API, bound to host loopback by default

## Storage

The local `./policies` directory is mounted read-only at `/policies`. OPA requires no persistent or named volume in this stack.

## Security Notes

- The API is exposed only on host loopback by default and has no built-in authentication in this stack.
- The container runs as user `1000:1000` with a read-only root filesystem, all Linux capabilities dropped, and `no-new-privileges` enabled.
- `/tmp` is a bounded temporary filesystem with executable and set-user-ID files disabled.
- Review policy data and add an authenticated gateway before exposing OPA beyond the local host.

## References

- [Open Policy Agent documentation](https://www.openpolicyagent.org/docs/)
- [OPA Docker Hub repository](https://hub.docker.com/r/openpolicyagent/opa)
- [OPA REST API](https://www.openpolicyagent.org/docs/rest-api/)
