# 🔐 Security Policy: StatusPulse Infrastructure

[cite_start]This document outlines the security hardening measures, vulnerability management, and secret handling protocols implemented for the StatusPulse project[cite: 294, 350].

## 1. Container Vulnerability Management (Task 6a)
[cite_start]We utilize **Trivy** to scan all Docker images for known vulnerabilities (CVEs)[cite: 296]. [cite_start]Our policy is to mitigate all **HIGH** and **CRITICAL** vulnerabilities before deployment[cite: 297].

### Scan Findings & Mitigations
| Component | Initial Finding | Mitigation Action | Result |
| :--- | :--- | :--- | :--- |
| **Base Image** | HIGH vulnerabilities found in `python:3.11`. | [cite_start]Switched to `python:3.11-slim`[cite: 207]. | [cite_start]0 HIGH vulnerabilities[cite: 298]. |
| **OS Packages** | Outdated system libraries. | [cite_start]Added `apt-get upgrade` to the Dockerfile[cite: 207]. | All OS CVEs patched. |
| **Dependencies** | Vulnerable binary packages. | [cite_start]Pinned `psycopg2-binary==2.9.9` in `requirements.txt`[cite: 202]. | Vulnerability resolved. |

> [cite_start]**Proof:** Before-and-after scan reports are available in `screenshots/task6/trivy_results.png`[cite: 310].

## 2. Secret Management Approach (Task 6b)
We strictly adhere to a **Zero-Secret Commit Policy**. [cite_start]No passwords, API keys, or private certificates are stored in version control[cite: 301, 312].

* [cite_start]**Local Development**: All sensitive configurations are stored in a local `.env` file, which is explicitly excluded via `.gitignore`[cite: 302].
* [cite_start]**CI/CD Pipeline**: Production credentials (SSH Keys, Docker Hub Tokens, Discord Webhooks) are managed via **GitHub Actions Secrets**[cite: 9, 303].
* [cite_start]**Runtime**: The application pulls secrets from environment variables, ensuring no hardcoded credentials exist in the source code[cite: 24, 301].

## 3. Network & Edge Security (Task 6c)
[cite_start]The production environment is protected by a hardened reverse proxy (Caddy) and OS-level firewall (UFW)[cite: 241, 244].

| Security Layer | Implementation | Purpose |
| :--- | :--- | :--- |
| **Rate Limiting** | [cite_start]100 requests/minute per IP[cite: 306]. | [cite_start]Prevents Brute-force and DoS attacks[cite: 315]. |
| **HSTS** | [cite_start]`Strict-Transport-Security`[cite: 307]. | [cite_start]Forces browsers to use HTTPS for all connections[cite: 246]. |
| **Anti-Sniffing** | [cite_start]`X-Content-Type-Options: nosniff`[cite: 307]. | Prevents browser MIME-type sniffing. |
| **Frame Protection**| [cite_start]`X-Frame-Options: DENY`[cite: 307]. | Protects against Clickjacking attacks. |
| **XSS Protection** | [cite_start]`X-XSS-Protection: 1; mode=block`[cite: 307].| Blocks pages when XSS attacks are detected. |

## 4. Server Hardening (Task 3a)
[cite_start]The host VM has been hardened to enterprise standards[cite: 239, 240]:
* [cite_start]**SSH**: Root login and password authentication are **disabled**[cite: 241].
* [cite_start]**Firewall**: UFW is active, permitting only ports 80, 443, and the custom SSH port[cite: 241].
* [cite_start]**Updates**: `unattended-upgrades` are enabled for automatic security patching[cite: 241].