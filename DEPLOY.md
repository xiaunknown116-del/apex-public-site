# Apex Capital Public Site – Deployment Guide

## Local preview
```bash
cd website
python3 -m http.server 8080
# → http://localhost:8080
```

## Production deployment (Cloudflare Pages)

1. Connect this repository to Cloudflare Pages.
2. Build settings: Framework preset None, output directory `/` (or the folder containing index.html).
3. Custom domain: `apexcapitalweb.com`
4. After first deploy, apply Cloudflare Access policy to staff routes (see docs/cloudflare-access-checklist.md).

## Required before go-live

- [ ] Cloudflare Access application protecting `/admin-login.html` (and `/admin/*`)
- [ ] Live Turnstile site key inserted into `contact.html`
- [ ] API endpoint validates Turnstile tokens server-side
- [ ] DNS for apexcapitalweb.com proxied through Cloudflare
- [ ] Bot Fight Mode (or Super Bot Fight Mode) enabled

## Account context
- Email linked to groups: Apex Capital, ApexCapitalWeb
- IP noted: 45.157.99.130
