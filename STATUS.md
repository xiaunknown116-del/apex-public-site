# Apex Public Site — Status

**Updated:** 2026-09-12

## Code complete & resilient
- Public site is pure static HTML (works on Pages even if API is down)
- Contact form uses fetch + in-page errors (no blank JSON page)
- Turnstile demo sitekey active until you set a real one
- API Worker: fails open on missing KV; uses demo Turnstile secret if secret unset
- `GET /api/health` reports binding issues as a list (self-diagnosing)

## What this system cannot auto-fix
Cloudflare **account** settings require your login:
- Connecting the Git repo to Pages
- Creating real KV namespaces and pasting ids
- Setting production secrets
- Access policies / custom domains / DNS

Without API tokens for your account, no tool can change those remotely.

## Operator checklist
1. Pages → Connect `apex-public-site` → empty build → output `/`
2. Domain → `apexcapitalweb.com`
3. Access → only admin paths (not the whole site)
4. `wrangler kv namespace create` ×2 → paste real ids into `wrangler.toml`
5. `wrangler secret put TURNSTILE_SECRET_KEY` + `ADMIN_TOKEN`
6. `wrangler deploy` → route `api.apexcapitalweb.com`
7. Replace demo Turnstile **sitekey** in `contact.html` for production

## Diagnose API after deploy
```bash
curl -s https://api.apexcapitalweb.com/api/health | jq .
# Look at "bindings" and "issues" arrays
```
