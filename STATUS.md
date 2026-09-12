# Apex Public Site — Build Status

**Last completed:** 2026-09-12

## Complete
- [x] index, platform, portfolio, governance, security, insights, contact
- [x] admin-login (Access guidance, no credential collection)
- [x] privacy, terms
- [x] institutional dark CSS (`assets/site.css`)
- [x] segregation + control-plane SVG diagrams
- [x] privacy-safe analytics / cookie stubs
- [x] Cloudflare Access checklist
- [x] DEPLOY.md
- [x] Global read-only banner

## Requires operator action (secrets / dashboard)
- [ ] Insert live Turnstile **site key** in `contact.html`
- [ ] Create KV namespaces and set IDs in `apex-sandbox-api` wrangler.toml
- [ ] `wrangler secret put TURNSTILE_SECRET_KEY`
- [ ] `wrangler secret put ADMIN_TOKEN`
- [ ] Apply Cloudflare Access policy to staff routes
- [ ] Connect repo to Cloudflare Pages / custom domain

## Related repos
- API: https://github.com/xiaunknown116-del/apex-sandbox-api
- Launch artifacts: https://github.com/xiaunknown116-del/apex-production-launch
- Control plane: https://github.com/xiaunknown116-del/admin-control-plane
