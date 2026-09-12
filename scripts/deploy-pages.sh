#!/usr/bin/env bash
# Direct-upload fallback for Cloudflare Pages (no GitHub Actions needed).
# Use this when the CI workflow can't run or you want a one-off deploy from your machine.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# --- Config (override with env vars) ---
PROJECT_NAME="${CF_PAGES_PROJECT:-apex-capital-web}"
BRANCH="${CF_PAGES_BRANCH:-main}"
COMMIT_HASH="${CF_PAGES_COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo local)}"

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  echo "ERROR: Set CLOUDFLARE_API_TOKEN (Pages Edit permission)."
  echo "  export CLOUDFLARE_API_TOKEN=your_token"
  exit 1
fi

if [ -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]; then
  echo "ERROR: Set CLOUDFLARE_ACCOUNT_ID."
  echo "  export CLOUDFLARE_ACCOUNT_ID=your_account_id"
  exit 1
fi

echo "Deploying $ROOT -> Pages project: $PROJECT_NAME (branch $BRANCH)"

# Create a tarball of the static site (exclude git/meta)
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

rsync -a --exclude '.git' --exclude 'node_modules' --exclude '.github' \
  --exclude 'scripts' --exclude '*.md' \
  "$ROOT/" "$STAGE/"

# Upload via direct upload API
UPLOAD_URL="https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PROJECT_NAME/deployments"

RESP=$(curl -sS -X POST "$UPLOAD_URL" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -F "branch=$BRANCH" \
  -F "commit_hash=$COMMIT_HASH" \
  -F "commit_message=Direct upload from deploy-pages.sh" \
  -F "manifest=@$STAGE")

echo "$RESP" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("result:", d.get("success")); print("url:", d.get("result",{}).get("url","(check dashboard)"))' 2>/dev/null || echo "$RESP"

echo "Done. Check: https://$PROJECT_NAME.pages.dev"
