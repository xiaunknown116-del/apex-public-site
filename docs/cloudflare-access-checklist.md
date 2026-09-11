# Apex Capital – Cloudflare Access & Turnstile Checklist

**Account email:** xiaunknown116@gmail.com  
**Associated groups:** Apex Capital · ApexCapitalWeb · IP 45.157.99.130 · Access token ID present

## 1. Protect Staff Boundary (Highest Priority)

Create a Cloudflare Access application that covers:

- `/admin-login.html`
- `/admin.html` (or any future control-plane paths)
- Optional: entire `/admin/*` prefix

**Recommended policy:**
- Identity provider: Google (or the identity already linked to the account)
- Require MFA
- Allow only the Apex Capital / ApexCapitalWeb groups (or specific emails)
- Session duration: short (e.g. 1–8 hours)
- Optional: restrict source IP to known operational ranges (including 45.157.99.130 if intentional)

This page must never collect credentials itself. All authentication happens at the Cloudflare Access layer.

## 2. Cloudflare Turnstile (Contact Form)

1. In the Cloudflare dashboard → Turnstile → Create widget.
2. Domains: `apexcapitalweb.com`, `apex-capital-web.pages.dev`, `localhost` (for testing).
3. Copy the **Site Key**.
4. Replace the placeholder in `contact.html`:

```html
<div class="cf-turnstile" data-sitekey="YOUR_LIVE_SITE_KEY" data-theme="dark"></div>
```

5. On the API side (`api.apexcapitalweb.com/api/contact`) validate the Turnstile response token server-side using the Secret Key. Never trust the client alone.

## 3. Pages / DNS Alignment

| Resource              | Current Target                     |
|-----------------------|------------------------------------|
| Production domain     | apexcapitalweb.com                 |
| Pages preview         | apex-capital-web.pages.dev         |
| Contact API           | api.apexcapitalweb.com/api/contact |
| Staff path protection | Cloudflare Access (Zero Trust)     |

Ensure the Pages project is linked to the ApexCapitalWeb group and that custom domain DNS is proxied through Cloudflare.

## 4. Radar / Bot Management

The account contains references to Cloudflare Radar bot-vs-human views.  
Recommended:
- Enable Bot Fight Mode or Super Bot Fight Mode on the zone.
- Review WAF custom rules if the IP 45.157.99.130 is expected traffic.
- Monitor the contact endpoint for abuse after Turnstile is live.

## 5. Immediate Actions

1. Apply Access policy to staff routes (do this before any public announcement).
2. Issue and insert live Turnstile site key.
3. Confirm API endpoint validates Turnstile tokens.
4. Remove or rotate any previously exposed recovery codes / tokens.
5. Deploy the completed `website/` folder to the Pages project.

---
Generated for Apex Capital institutional sandbox – 2026-09-11
