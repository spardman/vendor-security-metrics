# Systemic Security Gaps & Automatic Vendor Inputs (Metric #2)

An automated validation architecture built within a Windows 11 VM sandbox and synced to a cloud CI/CD pipeline. This repository tracks, audits, and mitigates software supply chain risks associated with automatic third-party vendor inputs.

## 🛠️ System Architecture
* **Local Inspection:** A custom PowerShell testing harness (`Test-VendorInput.ps1`) evaluating incoming vendor JSON manifests against baseline compliance policies.
* **Cloud Guardrails:** A containerized GitHub Actions workflow running on a `windows-latest` virtual host to audit every push and incoming pull request.
* **Branch Protection:** Strict repository rulesets preventing any code deployment if systemic vulnerabilities are detected.

## 📊 Security Metrics Evaluated
1. **Cryptographic Integrity:** Catches missing or invalid third-party digital signatures.
2. **Protocol Compliance:** Enforces modern transit security standards (blocking deprecated protocols like TLS 1.0/1.1).
3. **Least Privilege Enforcement:** Intercepts and flags unauthorized or excessive local administrator privilege elevation attempts.
