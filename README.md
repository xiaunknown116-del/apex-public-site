# Apex Capital — Public Site

Institutional, **read-only** public website.

**Posture**
- No client money, no live execution, no solicitation CTAs
- Staff routes intended for Cloudflare Access + MFA
- Contact form: Cloudflare Turnstile + API rate limit

**Best build settings (Cloudflare Pages)**
| Setting | Value |
|---------|--------|
| Framework preset | None |
| Build command | `exit 0` |
| Build output directory | `/` (repository root) |
| Production branch | `main` |

See [DEPLOY.md](./DEPLOY.md) for full steps.

**Local**
```bash
python3 -m http.server 8080
```

**Related**
- API: https://github.com/xiaunknown116-del/apex-sandbox-api
- Launch pack: https://github.com/xiaunknown116-del/apex-production-launch
- Control plane: https://github.com/xiaunknown116-del/admin-control-plane
