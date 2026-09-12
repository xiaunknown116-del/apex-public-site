# Deploy Apex Public Site — Cloudflare Pages (best way)

## Why this path
- Static HTML → Cloudflare Pages (global CDN, free SSL, Git-connected)
- No build step required
- Custom domain: apexcapitalweb.com
- Staff path protected separately with Cloudflare Access

## One-time setup

### 1. Cloudflare Pages (public site)
1. Dashboard → **Workers & Pages** → **Create** → **Pages** → Connect to Git
2. Select repo: `xiaunknown116-del/apex-public-site`
3. Build settings:
   - Framework preset: **None**
   - Build command: *(leave empty)*
   - Build output directory: `/` (root)
4. Save and deploy
5. Custom domains → add `apexcapitalweb.com` and `www` (DNS proxied through Cloudflare)

### 2. Turnstile (contact form)
1. Dashboard → **Turnstile** → Create widget
2. Domains: `apexcapitalweb.com`, `apex-capital-web.pages.dev`, `localhost`
3. Copy **Site Key** → replace `YOUR_SITE_KEY` in `contact.html` → commit/push
4. Copy **Secret Key** → set on Worker: `wrangler secret put TURNSTILE_SECRET_KEY`

### 3. Worker API (`apex-sandbox-api`)
```bash
cd apex-sandbox-api
# Create KV namespaces and paste ids into wrangler.toml
npx wrangler kv namespace create SANDBOX_KV
npx wrangler kv namespace create RATE_LIMIT_KV

npx wrangler secret put ADMIN_TOKEN
npx wrangler secret put TURNSTILE_SECRET_KEY

npx wrangler deploy
# Route/custom domain: api.apexcapitalweb.com → this Worker
```

### 4. Cloudflare Access (staff only)
1. Zero Trust → Access → Applications → Self-hosted
2. Protect `admin.apexcapitalweb.com` or `/admin-login.html`
3. Policy: Allow `@apexcapitalweb.com` + Require MFA, session 1h
4. See `docs/cloudflare-access-best-practice.md`

## Verify
- https://apexcapitalweb.com → 200, styled, read-only banner
- /contact → Turnstile widget visible
- /admin-login.html → Access login challenge
- POST /api/contact → rate limit + Turnstile + KV write

## Local preview
```bash
python3 -m http.server 8080
# http://localhost:8080
```
