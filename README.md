# Apex Capital — Public Site

Institutional, **read-only** public website.

**Posture**
- No client money, no live execution, no solicitation CTAs
- Staff routes intended for Cloudflare Access + MFA
- Contact form: Cloudflare Turnstile + API rate limit

**Deploy (best way)**  
Connect this repo to **Cloudflare Pages** (no build command, output `/`).  
See [DEPLOY.md](./DEPLOY.md).

**Local**
```bash
python3 -m http.server 8080
```

**Related**
- API: https://github.com/xiaunknown116-del/apex-sandbox-api
- Launch pack: https://github.com/xiaunknown116-del/apex-production-launch
- Control plane: https://github.com/xiaunknown116-del/admin-control-plane
