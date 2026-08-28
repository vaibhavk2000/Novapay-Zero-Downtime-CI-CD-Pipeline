# Deliverable 3 — Compliance Gate Framework

## Purpose
<<<<<<< HEAD
Each gate produces a pass/fail decision and evidence. Blocking failures stop promotion unless an approved, time-limited exception is recorded.

## Gate matrix

| Gate | Tool/category | Blocking rule | Remediation |
|---|---|---|---|
| Source integrity | GitHub validation | required checks fail | correct branch/change issue |
| Tests | Gradle/JUnit | test failure | fix or remove invalid change |
| Coverage | JaCoCo | line <80% or branch <70% | add meaningful tests |
| SAST | configured scanner | unresolved policy-blocking finding | remediate or approved exception |
| Dependency/secret scan | dependency scanner + Gitleaks | secret exposure or blocking finding | revoke/rotate secret and remediate |
| Container scan | Trivy or equivalent | policy-blocking vulnerability | update base image/dependency |
| SBOM | Syft or equivalent | artifact/evidence missing | regenerate and archive |
| Policy-as-code | OPA/Conftest | manifest violates required policy | correct manifest |
| Deployment verification | health/smoke checks | required check fails | stop promotion and rollback |

## Severity policy
Severity thresholds must be applied consistently with the scanner configuration committed to the repository. A recommended default is to block known exploitable or unresolved critical findings and require documented treatment for lower severities according to organizational policy.

## Exception workflow
1. Developer records the finding and business impact.
2. Security/platform owner reviews the risk and compensating controls.
3. Approver records scope and expiry.
4. Pipeline allows only the documented exception scope.
5. Exception expires automatically and requires re-review.

## Audit evidence
Store workflow run ID, commit SHA, artifact digest, gate name, timestamp, decision, exception ID (if any), and links to scan output. Evidence must be immutable or access-controlled in a production implementation.

## Policy examples
The repository contains Rego policies that require workloads to run as non-root and to define required probes. Policies are evaluated against rendered manifests rather than only source templates.
=======
Each gate produces a pass/fail decision and structured evidence. Blocking failures stop
promotion unless an approved, time-limited exception is recorded. Every gate below is mapped to
a specific RBI Master Direction section and/or PCI-DSS v4.0 requirement number, so the pipeline
functions as an automated, audit-ready control set rather than a generic scanning checklist.

## Gate matrix (6 gates, numeric thresholds, regulatory mapping)

| # | Gate | Tool | Blocking threshold | On failure | Exception process | RBI section | PCI-DSS req |
|---|---|---|---|---|---|---|---|
| 1 | SAST | Semgrep + configured scanner | 0 Critical, ≤2 High, coverage ≥80% line / ≥70% branch | Pipeline blocked, auto-ticket raised | CISO approval within 24h, time-bound | §5.1 (vulnerability assessment) | 6.2 (bespoke software security) |
| 2 | Secret scanning | Gitleaks | Any verified secret match | Pipeline blocked; secret must be revoked/rotated before merge | No exception permitted — secrets are always remediated, never waived | §5.4 (encryption/key handling) | 6.3 (security vulnerabilities) |
| 3 | Dependency & container scan | Trivy | 0 Critical CVE; High blocked at **CVSS ≥ 8.0** (see `ERRATA.md` Error 1); SBOM generated | Pipeline blocked if threshold breached | 72h remediation window, tracked to closure | §5.1, §7.2 (third-party risk) | 6.3, 11.3 |
| 4 | Policy-as-code (K8s manifests) | OPA/Conftest, 6 Rego policies | All policies pass against rendered Helm output | Deployment rejected | Dual approval override (platform lead + security) | §4.3 (segregation of duties), §5.4 | 6.4, 2.2 |
| 5 | Change management / approvals | GitHub branch protection + CODEOWNERS | 2 approving reviews, author cannot self-approve, signed commits | Merge blocked | N/A — structural control, not waivable | §4.2 (change management), §4.3 (SoD) | 6.5 |
| 6 | Deployment verification | Smoke tests + health checks | All required checks pass post-deploy | Stop promotion, trigger rollback | Manual override requires Release Manager + SRE sign-off | §6.1 (audit trails), §6.3 (incident mgmt) | 6.5, 10.2 |

## RBI Master Direction — full mapping reference

| RBI Section | Requirement summary | Pipeline control |
|---|---|---|
| 4.2 | Change management: testing, approval, rollback procedures | Gates 1–6 above + `pipeline/scripts/rollback.sh` |
| 4.3 | Segregation of duties between development and deployment | Branch protection (no self-approval) + CODEOWNERS routing + no standing prod credentials for developers |
| 5.1 | Vulnerability assessment performed regularly | SAST + dependency/container scan run on every commit, not periodically |
| 5.4 | Encryption of data in transit and at rest | Secret scanning gate + policy gate checks for TLS/encryption annotations on rendered manifests |
| 6.1 | Comprehensive audit trails for all system changes | Every workflow run, approval, and Conftest decision is logged as a GitHub Actions artifact with run ID, commit SHA, and timestamp |
| 6.3 | Incident management and business continuity | `runbooks/incident-playbook.md` + rollback specification |
| 7.2 | Third-party risk management | SBOM generation (Syft) archived on every build |

## PCI-DSS v4.0 — full mapping reference

| Req # | Title | Pipeline implementation |
|---|---|---|
| 6.2 | Bespoke software security | SAST gate + mandatory 2-reviewer approval before merge |
| 6.3 | Security vulnerabilities | Dependency scanning (Trivy) + secret scanning (Gitleaks) |
| 6.4 | Public-facing web app protection | DAST gate (documented; requires live target — see `ERRATA.md` limitations) |
| 6.5 | Change management processes | Environment promotion workflow (`docs/05-environment-promotion/`) + dual approvals |
| 2.2 | Secure configuration standards | OPA/Conftest policy gate (non-root, resource limits, no `:latest` tags, read-only root filesystem) |
| 10.2 | Audit log recording | GitHub Actions run logs + artifact retention |
| 11.3 | Penetration testing | DAST integration (documented gate; scheduled deeper pen tests out of scope for this repo) |

## Severity policy
Severity thresholds are applied consistently with the scanner configuration committed to the
repository (`app/build.gradle` for coverage; `pipeline/policies/*.rego` for manifest policy).
Known exploitable or unresolved Critical findings always block; High findings follow the CVSS ≥
8.0 threshold established in Error 1 of `ERRATA.md`. Lower severities require documented
treatment rather than an automatic exception.

## Exception workflow
1. Developer records the finding, business impact, and requested exception scope.
2. Security/platform owner reviews the risk and any compensating controls.
3. Approver records scope and an explicit expiry date/time.
4. The pipeline enforces only the documented exception scope — it cannot be broadened silently.
5. The exception expires automatically at the recorded time and requires re-review to renew.

## Audit evidence
Each gate decision is recorded with: workflow run ID, commit SHA, artifact digest, gate name,
timestamp, pass/fail decision, exception ID (if any), and a link to the scan output artifact.
In this repository, evidence is captured via GitHub Actions run artifacts and the screenshots in
`evidence/screenshots/`. In a production deployment this evidence would be written to an
immutable, access-controlled store (e.g. S3 with Object Lock, or a dedicated audit-log service)
rather than relying on CI artifact retention alone.

## Policy implementation
The repository contains six Rego policies evaluated against **rendered** Helm manifests (not
source templates), via Conftest:

| Policy file | Enforces |
|---|---|
| `require-nonroot.rego` | Containers must not run as root |
| `require-probes.rego` | Liveness and readiness probes must be defined |
| `require-resource-limits.rego` | CPU and memory limits must be set on every container |
| `disallow-privileged.rego` | `securityContext.privileged` must not be `true` |
| `disallow-latest-tag.rego` | Container image tag must not be `:latest` (traceability requirement) |
| `require-readonly-rootfs.rego` | Root filesystem must be mounted read-only where the workload allows it |
>>>>>>> 6c5a403 (update in project)
