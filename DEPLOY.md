# Apex Capital — Complete Deployment Steps

**Posture:** Public site is read-only / illustrative. No client money. Staff routes behind Cloudflare Access + MFA.

---

## Overview

| Surface | Product | Repo / source |
|---------|---------|----------------|
| Public website | Cloudflare Pages | `xiaunknown116-del/apex-public-site` |
| Contact API | Cloudflare Worker | `xiaunknown116-del/apex-sandbox-api` |
| Staff gate | Cloudflare Access | Zero Trust dashboard |
| Bot protection | Turnstile | Dashboard + site key in `contact.html` |

---

## Step 1 — Public site (Cloudflare Pages)

1. Open [Cloudflare Dashboard](https://dash.cloudflare.com) → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**.
2. Authorize GitHub and select **`xiaunknown116-del/apex-public-site`**.
3. Build settings:
   - **Framework preset:** None
   - **Build command:** *(leave empty)*
   - **Build output directory:** `/` (repository root)
4. Click **Save and Deploy**.
5. After the first deploy succeeds:
   - **Custom domains** → add `apexcapitalweb.com` and `www.apexcapitalweb.com`
   - Ensure DNS records are **proxied** (orange cloud) through Cloudflare.

**Verify:** `https://apexcapitalweb.com` loads with the institutional dark theme and read-only banner.

---

## Step 2 — Turnstile (contact form)

1. Dashboard → **Turnstile** → **Add widget**.
2. Widget domains:
   - `apexcapitalweb.com`
   - `www.apexcapitalweb.com`
   - `apex-capital-web.pages.dev`
   - `localhost` (for local testing)
3. Mode: **Managed** (recommended).
4. Copy the **Site Key** and **Secret Key**.
5. In this repo, open `contact.html` and replace:
   ```html
   data-sitekey="YOUR_SITE_KEY"
   ```
   with your real site key.
6. Commit and push to `main` — Pages will redeploy automatically.

**Secret key** is used only on the Worker (Step 3), never in frontend code.

---

## Step 3 — API Worker (`apex-sandbox-api`)

```bash
# Clone
git clone https://github.com/xiaunknown116-del/apex-sandbox-api.git
cd apex-sandbox-api
npm install

# Create KV namespaces
npx wrangler kv namespace create SANDBOX_KV
npx wrangler kv namespace create RATE_LIMIT_KV
# Also create preview namespaces if you use wrangler dev:
# npx wrangler kv namespace create SANDBOX_KV --preview
# npx wrangler kv namespace create RATE_LIMIT_KV --preview
```

Edit `wrangler.toml` and replace placeholders:

```toml
[[kv_namespaces]]
binding = "SANDBOX_KV"
id = "<paste-sandbox-kv-id>"

[[kv_namespaces]]
binding = "RATE_LIMIT_KV"
id = "<paste-rate-limit-kv-id>"
```

Set secrets (never commit these):

```bash
npx wrangler secret put TURNSTILE_SECRET_KEY
# paste the Turnstile secret key from Step 2

npx wrangler secret put ADMIN_TOKEN
# generate a long random token for admin wipe endpoint
```

Deploy:

```bash
npx wrangler deploy
```

Attach custom domain / route:

1. Workers & Pages → your Worker → **Triggers** / **Custom Domains**
2. Add **`api.apexcapitalweb.com`**
3. Confirm DNS is proxied

**Verify:**

```bash
curl -s https://api.apexcapitalweb.com/api/health
# expect JSON with ok: true, environment: controlled-sandbox
```

---

## Step 4 — Cloudflare Access (staff only)

1. **Zero Trust** → **Access controls** → **Applications** → **Add an application**.
2. Type: **Self-hosted**.
3. Name: `Apex Capital Staff`.
4. Application domain (pick one approach):
   - Preferred: `admin.apexcapitalweb.com`
   - Or path: `apexcapitalweb.com/admin-login.html`
5. Session duration: **1 hour**.
6. Policy:
   - **Action:** Allow
   - **Include:** Emails ending in `@apexcapitalweb.com`  
     *(or IdP groups: Apex Capital / ApexCapitalWeb)*
   - **Require:** Authentication method → **MFA**
7. Optional harden: also **Require** IP `45.157.99.130/32` if that address is intentional.
8. Save.

**Verify:** open `/admin-login.html` (or admin host) in a private window → Access login challenge.  
**Verify:** public homepage still loads **without** Access challenge.

Full policy notes: `docs/cloudflare-access-best-practice.md`

---

## Step 5 — End-to-end checks

| Check | Expected |
|-------|----------|
| `https://apexcapitalweb.com` | 200, styled, read-only banner |
| `/contact` | Turnstile widget visible |
| Submit contact (valid) | In-page success message; inquiry stored in SANDBOX_KV |
| Submit contact (no token) | Error / 403 |
| Rapid submits | 429 after limit |
| `/admin-login.html` | Access login (staff only) |
| `GET /api/health` | `ok: true`, sandbox flags |

---

## Local development

```bash
# Public site
cd apex-public-site   # or local website folder
python3 -m http.server 8080
# http://localhost:8080

# Worker (separate terminal)
cd apex-sandbox-api
npx wrangler dev
# http://127.0.0.1:8787
```

Point the contact form temporarily at `http://127.0.0.1:8787/api/contact` only for local tests if needed.

---

## Rollback

- **Pages:** Deployments → select previous deployment → **Rollback**
- **Worker:** `npx wrangler deployments list` then `npx wrangler rollback`
- **Access:** disable or delete the application to open the path again (not recommended in production)

---

## Security reminders

- Never commit Turnstile **secret** or `ADMIN_TOKEN`
- Public site must remain free of live funding/trading CTAs
- Dual-control WebAuthn for approvals is separate from Access (Access only gates entry to staff UI)
- Rotate secrets if they were ever pasted into chat or committed by mistake
