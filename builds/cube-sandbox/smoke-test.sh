#!/usr/bin/env bash
# Smoke test for a running CubeSandbox stack.
#
# Run from the WSL2 host or from inside the cube-sandbox container - both work
# because the container uses network_mode: host.
#
# Steps:
#   1. Health-check all CubeSandbox services
#   2. (Optional, slow) Build a code-interpreter template from a public image
#   3. Create a sandbox via the E2B-compatible REST API, run a tiny payload,
#      then destroy it
#
# Skip the slow template-build step with: SKIP_TEMPLATE_BUILD=1 ./smoke-test.sh
set -euo pipefail

# cubemastercli is installed to a non-standard prefix; add it to PATH so this
# script works both when run inside the container and from the WSL2 host.
export PATH="/usr/local/services/cubetoolbox/CubeMaster/bin:${PATH:-}"

CUBE_API="${CUBE_API:-http://127.0.0.1:3000}"
CUBE_MASTER="${CUBE_MASTER:-http://127.0.0.1:8089}"
CUBE_NETAGENT="${CUBE_NETAGENT:-http://127.0.0.1:19090}"

ok()   { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[1;36m[INFO]\033[0m %s\n' "$*"; }

#-------------------------------------------------------------------
# 1. Health checks (matches what install.sh's quickcheck.sh verifies)
#-------------------------------------------------------------------
info "Health: CubeAPI"
curl -fsS "${CUBE_API}/health"        >/dev/null && ok "CubeAPI /health"        || fail "CubeAPI /health"
echo

info "Health: CubeMaster"
curl -fsS "${CUBE_MASTER}/notify/health" >/dev/null && ok "CubeMaster /notify/health" || fail "CubeMaster /notify/health"

info "Health: network-agent"
curl -fsS "${CUBE_NETAGENT}/healthz" >/dev/null && ok "network-agent /healthz"  || fail "network-agent /healthz"
curl -fsS "${CUBE_NETAGENT}/readyz"  >/dev/null && ok "network-agent /readyz"   || fail "network-agent /readyz"

#-------------------------------------------------------------------
# 2. Optional: build a sandbox template
#-------------------------------------------------------------------
TEMPLATE_ID="${CUBE_TEMPLATE_ID:-}"

if [ -z "$TEMPLATE_ID" ] && [ "${SKIP_TEMPLATE_BUILD:-0}" != "1" ]; then
    info "No CUBE_TEMPLATE_ID provided; building one from ccr.ccs.tencentyun.com/ags-image/sandbox-code:latest"
    info "(this can take 5-15 minutes; set SKIP_TEMPLATE_BUILD=1 to skip and only run health checks)"

    if ! command -v cubemastercli >/dev/null 2>&1; then
        # cubemastercli lives inside the container; exec into it
        CUBE_CTR="$(docker compose ps -q cube-sandbox 2>/dev/null || true)"
        [ -z "$CUBE_CTR" ] && fail "cube-sandbox container not running and cubemastercli not on PATH"
        CMC="docker exec -i $CUBE_CTR cubemastercli"
    else
        CMC="cubemastercli"
    fi

    JOB_OUT="$($CMC tpl create-from-image \
        --image ccr.ccs.tencentyun.com/ags-image/sandbox-code:latest \
        --writable-layer-size 1G \
        --expose-port 49999 \
        --expose-port 49983 \
        --probe 49999 2>&1)"
    echo "$JOB_OUT"
    JOB_ID="$(echo "$JOB_OUT" | grep -oE 'job_id[=: ]+[A-Za-z0-9_-]+' | head -1 | awk '{print $NF}')"
    [ -z "$JOB_ID" ] && fail "could not parse job_id from output"
    info "Watching job $JOB_ID ..."
    $CMC tpl watch --job-id "$JOB_ID"
    # Extract template_id from the create-from-image output (it's on the first few
    # lines) rather than re-querying the list — list ordering is not guaranteed and
    # could return a FAILED entry as the last line.
    TEMPLATE_ID="$(echo "$JOB_OUT" | grep -E '\btemplate_id\b' | head -1 | awk '{print $NF}')"
    [ -z "$TEMPLATE_ID" ] && fail "could not determine template id after build"
    ok "Template built: $TEMPLATE_ID"
elif [ -z "$TEMPLATE_ID" ]; then
    info "Skipping sandbox lifecycle test (no CUBE_TEMPLATE_ID and SKIP_TEMPLATE_BUILD=1)"
    ok "Health checks passed - CubeSandbox stack is up"
    exit 0
fi

#-------------------------------------------------------------------
# 3. Create -> inspect -> destroy a sandbox via REST
#-------------------------------------------------------------------
info "Creating sandbox from template $TEMPLATE_ID ..."
RESP="$(curl -fsS -X POST "${CUBE_API}/sandboxes" \
    -H 'Authorization: Bearer dummy' \
    -H 'Content-Type: application/json' \
    -d "{\"templateID\":\"${TEMPLATE_ID}\"}")"
SANDBOX_ID="$(echo "$RESP" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("sandboxID",""))')"
[ -z "$SANDBOX_ID" ] && fail "no sandboxID in response: $RESP"
ok "Created sandbox $SANDBOX_ID"

info "Inspecting sandbox ..."
curl -fsS "${CUBE_API}/sandboxes/${SANDBOX_ID}" -H 'Authorization: Bearer dummy' \
    | python3 -m json.tool
ok "Sandbox is queryable"

info "Destroying sandbox ..."
curl -fsS -X DELETE "${CUBE_API}/sandboxes/${SANDBOX_ID}" -H 'Authorization: Bearer dummy' >/dev/null
ok "Sandbox destroyed"

ok "All smoke tests passed"
