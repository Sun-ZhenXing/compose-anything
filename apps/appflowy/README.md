# AppFlowy Cloud (legacy)

This is the archived public AppFlowy Cloud `0.9.64` desktop backend. It is not a browser note editor and makes no current-commercial-self-hosting claim. Upstream stopped maintenance on 2026-09-01; do not assume compatibility with the latest desktop client.

## Services

`postgres`, `redis`, `minio`, `gotrue`, `appflowy_cloud`, `admin_frontend`, and the local-only `nginx` gateway. There is no web image, AI service, worker, SMTP server, or extra SQL init container. The release embeds its SQL migrations and GoTrue performs the auth bootstrap.

## Quick start

```bash
cd apps/appflowy
python3 setup.py                 # Windows: py -3 setup.py
docker compose up -d
```

`make init` uses an isolated Python container with CPU and memory bounds; on Windows use the Python command above if GNU Make is unavailable. Check startup with `docker compose ps` and `docker compose config -q`. The gateway is at <http://localhost:8080>; the exact administrator login URL is <http://localhost:8080/console/web/login>.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `APPFLOWY_PORT_OVERRIDE` | `8080` | Loopback host port |
| `APPFLOWY_BASE_URL` | `http://localhost:8080` | External URL, including the chosen port |
| `APPFLOWY_*_VERSION` | pinned `0.9.64` or registry release | Image references; tags include immutable digests for AppFlowy images |
| `APPFLOWY_ADMIN_EMAIL` | `admin@example.com` | Bootstrap administrator |
| `APPFLOWY_POSTGRES_PASSWORD`, `APPFLOWY_ADMIN_PASSWORD`, `APPFLOWY_JWT_SECRET`, `APPFLOWY_MINIO_*`, `APPFLOWY_ADMIN_OAUTH_CLIENT_SECRET`, `APPFLOWY_GOTRUE_OPERATOR_TOKEN` | generated | Seven secrets; never commit `.env` |

Default limits are PostgreSQL `1 CPU/1G`, Redis `0.5 CPU/256M`, MinIO `1 CPU/1G`, GoTrue `0.5 CPU/256M`, Cloud `2 CPU/2G`, admin `0.5 CPU/256M`, and Nginx `0.25 CPU/64M`.

`setup.py` creates `.env` exclusively with POSIX mode `0600`, refuses to overwrite it, and is initialization rather than rotation. The generated administrator password is the value of `APPFLOWY_ADMIN_PASSWORD` in that local file; read it locally without printing it to shared logs. Change `APPFLOWY_BASE_URL` together with a non-default published port. The upstream container names and internal URLs are deliberately hidden behind the gateway.

## Storage, security, and upgrades

Named volumes are `appflowy_postgres_data`, `appflowy_redis_data`, and `appflowy_minio_data`. PostgreSQL, Redis, and MinIO have no host ports. Services use resource limits, JSON log rotation, dropped capabilities, and a loopback-only gateway. The vendor images retain only the permissions needed for their own startup; cloud and admin use read-only roots with `/tmp` tmpfs.

Back up the database and all volumes before any migration. Never use `docker compose down -v` on real data. Change the full image reference deliberately and validate a copy of the volumes first; this is a legacy release with no promise of latest desktop compatibility.

This stack does not provide a browser editor, SMTP delivery, AI, workers, imports, or published pages. SMTP is deliberately pointed at loopback and invitations are not a delivery mechanism. Bootstrap administrator authentication is tested; additional-user provisioning is untested. The bounded stdlib smoke test covers password auth, closed signup, user verification, workspace/page creation and persistence across Cloud and gateway recreation, blob upload/read, WebSocket HTTP upgrade, and token absence from captured service logs. The pinned release's working blob handler was observed at `/api/file_storage/{workspace_id}/v1/blob/{parent_dir}/{file_id}` and allowed anonymous reads; treat attachment URLs as public. Actual desktop login, editing, and synchronization are not verified, and no compatible desktop client version has been tested against this archived backend.

Run the disposable runtime check with `python smoke.py`; it creates a random temporary Compose project and free loopback port, then removes only its containers, network, and named volumes.

## References

- [Archived backend release](https://github.com/AppFlowy-IO/AppFlowy-Cloud/releases/tag/0.9.64)
- [Archived repository status](https://github.com/AppFlowy-IO/AppFlowy-Cloud)
- [Versioned Compose source](https://raw.githubusercontent.com/AppFlowy-IO/AppFlowy-Cloud/0.9.64/docker-compose.yml)
