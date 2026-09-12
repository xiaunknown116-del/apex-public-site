#!/usr/bin/env bash
# Direct-upload fallback for Cloudflare Pages (no GitHub Actions needed).
# Use when CI can't run or you want a one-off deploy from your machine.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

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

if [ ! -f "index.html" ]; then
  echo "ERROR: index.html not found in $ROOT"
  exit 1
fi

echo "Deploying $ROOT -> Pages project: $PROJECT_NAME (branch $BRANCH)"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# Copy static site, exclude git/meta/docs/scripts
for f in index.html contact.html platform.html portfolio.html governance.html security.html insights.html admin-login.html privacy.html terms.html _headers _redirects 404.html robots.txt sitemap.xml; do
  [ -f "$f" ] && cp "$f" "$STAGE/"
done
mkdir -p "$STAGE/assets"
cp -r assets/* "$STAGE/assets/" 2>/dev/null || true

# Build a simple file manifest (path -> hash) for the direct upload API
MANIFEST="$STAGE/manifest.json"
{
  echo "{"
  first=1
  find "$STAGE" -type f ! -name manifest.json | sort | while read -r file; do
    rel="${file#$STAGE/}"
    hash=$(sha256sum "$file" | awk '{print $1}')
    if [ $first -eq 1 ]; then first=0; else echo ","; fi
    printf '  "%s": "%s"' "$rel" "$hash"
  done
  echo
  echo "}"
} > "$MANIFEST"

UPLOAD_URL="https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PROJECT_NAME/deployments"

RESP=$(curl -sS -X POST "$UPLOAD_URL" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -F "branch=$BRANCH" \
  -F "commit_hash=$COMMIT_HASH" \
  -F "commit_message=Direct upload from deploy-pages.sh" \
  -F "manifest=@$MANIFEST")

echo "$RESP" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("success:", d.get("success")); print("url:", d.get("result",{}).get("url","(check dashboard)"))' 2>/dev/null || echo "$RESP"

echo "Done. Check: https://$PROJECT_NAME.pages.dev"
