# Deliverable 3 — Compliance Gate Framework

## Purpose
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
