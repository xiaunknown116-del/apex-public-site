# Cloudflare Access — Best Practice for Apex Capital

## Goal
Protect staff / admin surfaces only. Public site stays open and read-only.

## Recommended setup (best way)

### 1. Application
- **Type:** Self-hosted  
- **Name:** Apex Capital Staff  
- **Session duration:** 1 hour  
- **Destinations:**
  - `admin.apexcapitalweb.com` (preferred dedicated host)
  - or path: `apexcapitalweb.com/admin-login.html`
  - staging: `apex-capital-web.pages.dev/admin-login.html`

### 2. Primary policy (`apex-staff-allow`)

| Action | Rule type | Selector | Value |
|--------|-----------|----------|--------|
| Allow | Include | Emails ending in | `@apexcapitalweb.com` |
| | Require | Authentication method | **MFA** |

- Session: **1 hour**
- Default deny for everyone else

### 3. Optional hardened policy (`apex-staff-allow-ip-hardened`)
Same as above, plus:

| Rule type | Selector | Value |
|-----------|----------|--------|
| Require | IP | `45.157.99.130/32` |

Use only if that IP is a stable, intentional ops address.

### 4. Identity
- Primary IdP: **Google** (or the IdP already linked to the account)
- Map groups **Apex Capital** / **ApexCapitalWeb** if using IdP groups instead of email domain
- OTP: break-glass only, not day-to-day staff access

### 5. What stays outside Access
- Public pages (`/`, `/platform`, `/portfolio`, `/governance`, `/contact`, …)
- Contact API (protected by Turnstile + rate limit instead)

### 6. Dashboard steps
1. Zero Trust → Access controls → Applications → Add application  
2. Self-hosted → set domain/path → session 1h  
3. Add policy → Allow → Include email domain → Require MFA  
4. Save → test in private window (expect Access login)  
5. Confirm public pages still load without Access challenge  

### 7. After Access is live
- Staff never type passwords into `admin-login.html` (that page is guidance only)
- Approvals inside the control plane still require WebAuthn (separate from Access)
- Rotate any previously exposed tokens / recovery codes

See also: `cloudflare-access-policy.json` and `cloudflare-access-checklist.md`.
