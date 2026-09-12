# Apex Public Site — Status

**Updated:** 2026-09-12

## Code complete
- [x] All public pages (index, platform, portfolio, governance, security, insights, contact, privacy, terms)
- [x] admin-login.html (Access guidance only)
- [x] Institutional CSS + SVG diagrams
- [x] Contact form via fetch (no raw JSON navigation)
- [x] Turnstile widget (Cloudflare **test** sitekey for demo)
- [x] Security headers (`_headers`) + redirects (`_redirects`)
- [x] DEPLOY.md full steps
- [x] Access policy docs

## Operator-only remaining (cannot automate without your Cloudflare login)

| # | Item | Action |
|---|------|--------|
| 1 | **Production Turnstile site key** | Create widget → replace `1x00000000000000000000AA` in `contact.html` |
| 2 | **Worker secrets** | `wrangler secret put TURNSTILE_SECRET_KEY` (use real secret, or test secret `1x0000000000000000000000000000000AA` for demos) |
| 3 | **KV namespace IDs** | Create `SANDBOX_KV` + `RATE_LIMIT_KV` → paste into `apex-sandbox-api` `wrangler.toml` |
| 4 | **Deploy Pages** | Connect this repo to Cloudflare Pages (no build, output `/`) |
| 5 | **Deploy Worker** | `npx wrangler deploy` + domain `api.apexcapitalweb.com` |
| 6 | **Cloudflare Access** | Protect admin path: Allow email domain + Require MFA, session 1h |

## Demo Turnstile keys (official Cloudflare test keys)
- Sitekey (always pass): `1x00000000000000000000AA`
- Secret (always pass): `1x0000000000000000000000000000000AA`

**Do not use test keys in production** — they always pass and provide no bot protection.
