# Deliverable 1 — Pipeline Architecture

<<<<<<< HEAD
=======
## Architecture diagram

![NovaPay CI/CD Pipeline Architecture](diagrams/novapay-cicd-architecture.png)

>>>>>>> 6c5a403 (update in project)
## 1. Overview

NovaPay uses a regulated CI/CD pipeline designed to provide fast developer feedback while enforcing quality, security, compliance and deployment controls.

The pipeline contains eight primary stages:

1. Source Validation
2. Build
3. Test and Coverage
4. SAST and Code Quality
5. Dependency and Secret Scanning
6. Container Build, SBOM and Image Scanning
7. Policy and Compliance Validation
8. Deployment Verification

Stages that do not depend on each other execute in parallel to reduce pipeline duration.

---

# 2. Pipeline Flow

```text
Developer Push / Pull Request
            |
            v
    [1] Source Validation
            |
            v
        [2] Build
            |
            +-------------------+-------------------+
            |                   |                   |
            v                   v                   v
      [3] Testing          [4] SAST          [5] Security
            |                   |                   |
            +-------------------+-------------------+
                                |
                                v
                  [6] Container + SBOM + Scan
                                |
                                v
                    [7] Policy / Compliance
                                |
                                v
                    [8] Deployment Verification
                                |
                                v
                        Promote or Rollback
````

---

# 3. Stage 1 — Source Validation

## Purpose

Validate the source code before expensive build and security processes begin.

## Tool and Version

* GitHub Actions
* GitHub Checkout Action v4
* Gitleaks v2

## Configuration Parameters

* Branch protection enabled for `main`
* Pull request required before production promotion
* Full repository checkout for security analysis
* Secret scanning enabled
* Git history inspected for exposed credentials

## Threshold Values

| Check                                      | Threshold |
| ------------------------------------------ | --------- |
| Hard-coded secrets                         | 0 allowed |
| Unapproved direct push to protected branch | 0 allowed |
| Invalid workflow YAML                      | 0 allowed |

## Failure Mode

The pipeline stops immediately when a secret or invalid configuration is detected.

## Remediation

1. Remove the exposed secret.
2. Rotate the affected credential.
3. Remove the secret from source code.
4. Store the credential in GitHub Secrets or an approved secret-management system.
5. Re-run the pipeline.

## Retry and Skip Logic

* Retry once for temporary GitHub Actions infrastructure failures.
* Security checks cannot be skipped without an approved exception.
* Protected branch validation cannot be bypassed.

## SLA Target

**Target completion: less than 3 minutes.**

---

# 4. Stage 2 — Build

## Purpose

Compile the NovaPay application and create a reproducible application artifact.

## Tool and Version

* Java 21
* Gradle 8.x
* Spring Boot 3.x

## Configuration Parameters

```text
Java Version: 21
Build Tool: Gradle
Build Command: ./gradlew clean build
Dependency Cache: Enabled
```

## Threshold Values

| Check                        | Threshold |
| ---------------------------- | --------- |
| Compilation errors           | 0 allowed |
| Failed dependency resolution | 0 allowed |
| Build artifact generation    | Required  |

## Failure Mode

A compilation or dependency resolution failure blocks all later stages.

## Remediation

1. Review the Gradle output.
2. Fix compilation errors.
3. Resolve dependency conflicts.
4. Rebuild locally.
5. Push the corrected change.

## Retry and Skip Logic

* Retry dependency download failures once.
* Build failures cannot be skipped.

## SLA Target

**Target completion: less than 5 minutes.**

---

# 5. Stage 3 — Testing and Coverage

## Purpose

Validate application functionality and prevent insufficient test coverage.

## Tool and Version

* JUnit 5
* Spring Boot Test
* JaCoCo

## Configuration Parameters

```text
Test Command:
./gradlew test jacocoTestReport
```

## Threshold Values

| Metric                 | Minimum Threshold |
| ---------------------- | ----------------- |
| Unit tests             | 100% pass         |
| Line coverage          | >= 80%            |
| Branch coverage        | >= 70%            |
| Critical payment tests | 100% pass         |

## Failure Mode

The pipeline blocks promotion when tests fail or coverage is below the required threshold.

## Remediation

1. Investigate failed tests.
2. Fix the application or test.
3. Add missing test coverage.
4. Run tests locally.
5. Push the updated code.

## Retry and Skip Logic

* Automatically retry flaky infrastructure-related failures once.
* Coverage gates cannot be skipped without an approved exception.

## SLA Target

**Target completion: less than 10 minutes.**

---

# 6. Stage 4 — SAST and Code Quality

## Purpose

Detect security vulnerabilities and maintain code quality standards.

## Tool and Version

* SonarQube or SonarCloud
* Semgrep

## Configuration Parameters

* Quality gate enabled
* Java and Spring Boot rules enabled
* Security hotspot analysis enabled
* Full pull request analysis enabled

## Threshold Values

| Finding                  | Threshold                           |
| ------------------------ | ----------------------------------- |
| Critical vulnerabilities | 0 allowed                           |
| High vulnerabilities     | 0 allowed unless approved exception |
| Quality gate             | Must pass                           |
| New code coverage        | >= 80%                              |

## Failure Mode

A failed quality gate or critical security finding blocks promotion.

## Remediation

1. Review the finding.
2. Fix the vulnerable code.
3. Add or update tests.
4. Re-run SAST.
5. Document false positives through the exception process.

## Retry and Skip Logic

* Scanner infrastructure failures may be retried once.
* Critical security findings cannot be skipped.
* False positives require documented approval and expiry.

## SLA Target

**Target completion: less than 10 minutes.**

---

# 7. Stage 5 — Dependency and Secret Scanning

## Purpose

Detect vulnerable third-party dependencies and exposed credentials.

## Tool and Version

* Trivy
* Gitleaks
* Optional: Grype

## Configuration Parameters

* Scan application dependencies
* Scan lock files and build metadata
* Scan full Git history for secrets
* Generate machine-readable scan reports

## Threshold Values

| Finding                             | Threshold                      |
| ----------------------------------- | ------------------------------ |
| Exposed secrets                     | 0 allowed                      |
| Critical dependency vulnerabilities | 0 allowed                      |
| High dependency vulnerabilities     | Must be remediated or approved |
| Known malicious package             | 0 allowed                      |

## Failure Mode

Critical vulnerabilities or exposed credentials stop the pipeline.

## Remediation

1. Upgrade or replace the vulnerable dependency.
2. Rotate exposed credentials.
3. Remove secrets from source history where required.
4. Re-run the security scans.

## Retry and Skip Logic

* Retry scanner network failures once.
* Security findings require remediation or a time-bound exception.
* Permanent skipping is not allowed.

## SLA Target

**Target completion: less than 8 minutes.**

---

# 8. Stage 6 — Container Build, SBOM and Image Scan

## Purpose

Create a deployable container image and validate its software supply chain.

## Tool and Version

* Docker BuildKit
* Trivy
* Syft
* Cosign

## Configuration Parameters

```text
Base Image: Approved Java 21 runtime
Container User: Non-root
SBOM Format: SPDX or CycloneDX
Image Tag: Git commit SHA
Image Scan: HIGH and CRITICAL severity
```

## Threshold Values

| Check                          | Threshold                   |
| ------------------------------ | --------------------------- |
| Container running as root      | Not allowed                 |
| Critical image vulnerabilities | 0 allowed                   |
| High image vulnerabilities     | 0 unless approved           |
| SBOM generation                | Mandatory                   |
| Image signing                  | Mandatory before production |

## Failure Mode

The container cannot proceed to deployment when mandatory security checks fail.

## Remediation

1. Update the base image.
2. Upgrade vulnerable packages.
3. Remove unnecessary dependencies.
4. Rebuild the image.
5. Generate a new SBOM.

## Retry and Skip Logic

* Retry image registry or temporary network failures once.
* Critical vulnerabilities cannot be skipped without a formal exception.

## SLA Target

**Target completion: less than 12 minutes.**

---

# 9. Stage 7 — Policy and Compliance Validation

## Purpose

Validate Kubernetes and infrastructure configuration against NovaPay security and compliance requirements.

## Tool and Version

* Open Policy Agent
* Conftest
* Optional Kyverno

## Configuration Parameters

Policies validate:

* Non-root containers
* Required readiness probes
* Required liveness probes
* Resource limits
* Approved container registries
* No privileged containers
* Required labels and audit metadata

## Threshold Values

| Policy Violation            | Threshold |
| --------------------------- | --------- |
| Critical policy violation   | 0 allowed |
| Missing readiness probe     | 0 allowed |
| Privileged container        | 0 allowed |
| Non-approved image registry | 0 allowed |
| Missing resource limits     | 0 allowed |

## Failure Mode

Any mandatory policy violation blocks deployment.

## Remediation

1. Correct the Kubernetes or infrastructure configuration.
2. Run policy checks locally.
3. Submit the corrected change.
4. Re-run the pipeline.

## Retry and Skip Logic

* Policy engine infrastructure failures may be retried once.
* Policy violations cannot be skipped without an approved, time-limited exception.

## SLA Target

**Target completion: less than 5 minutes.**

---

# 10. Stage 8 — Deployment Verification

## Purpose

Verify that the deployed application is healthy before further promotion.

## Tool and Version

* Kubernetes
* Argo CD
* Istio
* Prometheus
* OWASP ZAP for non-production DAST

## Configuration Parameters

The verification process includes:

* Kubernetes readiness checks
* Kubernetes liveness checks
* Application smoke tests
* HTTP error-rate monitoring
* p99 latency monitoring
* Canary metric comparison
* DAST in non-production

## Threshold Values

| Metric                   | Threshold          |
| ------------------------ | ------------------ |
| Required replicas ready  | 100%               |
| Smoke tests              | 100% pass          |
| HTTP 5xx error rate      | <= 5%              |
| Critical DAST findings   | 0 allowed          |
| Severe readiness failure | Immediate rollback |
| SLO breach during canary | Stop promotion     |

## Failure Mode

Promotion is frozen when verification fails. Production failures follow the rollback process defined in Deliverable 6.

## Remediation

1. Freeze traffic promotion.
2. Collect logs and metrics.
3. Correlate the failure.
4. Roll back when Category A or Category B conditions are met.
5. Open an incident record.

## Retry and Skip Logic

* Smoke tests may retry once for transient network failures.
* Production verification cannot be skipped.
* Rollback requires post-rollback verification.

## SLA Target

**Initial verification: less than 10 minutes.**

---

# 11. Job Dependencies and Parallelisation

The GitHub Actions workflow should use dependencies to avoid unnecessary waiting.

```text
Source Validation
       |
       v
      Build
       |
       +-----------------------------+
       |             |               |
       v             v               v
    Testing        SAST      Dependency Scan
       |             |               |
       +-------------+---------------+
                     |
                     v
             Container Build
                     |
                     v
              SBOM + Image Scan
                     |
                     v
          Policy / Compliance Gate
                     |
                     v
              Deploy + Verify
```

Parallel execution reduces total pipeline duration while preserving mandatory quality and security gates.

---

# 12. Pipeline Failure Strategy

A failure is handled according to its category:

| Failure Type                    | Action                       |
| ------------------------------- | ---------------------------- |
| Source validation failure       | Stop immediately             |
| Build failure                   | Stop pipeline                |
| Test failure                    | Stop pipeline                |
| Coverage failure                | Block promotion              |
| Critical security finding       | Block promotion              |
| Policy violation                | Block deployment             |
| Non-production DAST failure     | Block promotion              |
| Production verification failure | Freeze and evaluate rollback |

---

# 13. Exception Workflow

A compliance or security exception must include:

* Exception ID
* Pipeline run ID
* Commit SHA
* Finding
* Risk justification
* Approver
* Expiry date
* Remediation owner

Exceptions must be time-limited and reviewed before expiry.

---

# 14. SLA Summary

| Stage                      | Target       |
| -------------------------- | ------------ |
| Source Validation          | < 3 minutes  |
| Build                      | < 5 minutes  |
| Testing and Coverage       | < 10 minutes |
| SAST                       | < 10 minutes |
| Dependency and Secret Scan | < 8 minutes  |
| Container + SBOM + Scan    | < 12 minutes |
| Policy Validation          | < 5 minutes  |
| Deployment Verification    | < 10 minutes |


