# Apex Capital — Public Site

Institutional, read-only public website for Apex Capital.

**Posture**
- Public surface is strictly illustrative / read-only
- No client money acceptance, no live execution, no solicitation CTAs
- Speculative product cards marked Concept — Not Live
- Staff paths intended to sit behind Cloudflare Access + MFA
- Contact form protected by Cloudflare Turnstile (site key to be inserted)

**Local preview**
```bash
python3 -m http.server 8080
# → http://localhost:8080
```

**Production**
- Domain: apexcapitalweb.com
- Pages preview: apex-capital-web.pages.dev
- API contact: api.apexcapitalweb.com/api/contact

See `DEPLOY.md` and `docs/cloudflare-access-checklist.md` for deployment and Zero Trust configuration.
