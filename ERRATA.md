# ERRATA

<<<<<<< HEAD
This register separates **assessment-source corrections** from **project implementation limitations**.

## Required correction register

The assessment requires three deliberate technical errors to be identified and corrected. The current project repository does not contain the complete source locations and evidence for all three errors, so they must not be invented.

### Error 1 — Assessment source
- Source location: **To be completed from the assessment document**
- Original statement: **To be copied exactly**
- Why it is incorrect: **To be supported by evidence**
- Correct statement: **To be completed**
- Evidence/reference: **To be completed**

### Error 2 — Assessment source
- Source location: **To be completed from the assessment document**
- Original statement: **To be copied exactly**
- Why it is incorrect: **To be supported by evidence**
- Correct statement: **To be completed**
- Evidence/reference: **To be completed**

### Error 3 — Assessment source
- Source location: **To be completed from the assessment document**
- Original statement: **To be copied exactly**
- Why it is incorrect: **To be supported by evidence**
- Correct statement: **To be completed**
- Evidence/reference: **To be completed**

## Project implementation limitations

### Simulated deployment environments
The repository does not connect to an external Kubernetes cluster or production infrastructure. Non-production deployment, progressive production deployment, DAST, smoke testing and post-deployment verification are therefore represented by validation/simulation steps.

### DAST limitation
A full dynamic scan requires a reachable running target. The project documents the intended DAST gate, but a live target must be supplied before treating this as a production DAST result.

### Progressive delivery limitation
The intended canary sequence is represented in the workflow and documentation. Actual weighted traffic shifting requires an integrated platform such as Istio, Argo Rollouts, or an equivalent deployment controller.

### Coverage and policy controls
JaCoCo enforces the configured line and branch coverage thresholds. Helm-rendered manifests are checked by Rego/Conftest policies for the repository's configured workload requirements.
=======
This register documents the three deliberate technical errors planted in the Zetheta assessment
document ("DevOps & Cloud Engineer – Zero-Downtime CI/CD Pipeline Assessment"), per the
instruction in Section A8: *"This document contains exactly THREE (3) deliberate technical
errors... One error is in Part A, one in Part C, and one in Part D."*

Each entry below is backed by a direct textual inconsistency inside the assessment document
itself, not an external claim.

---

## Error 1 — Part A (Section A2.2 vs Section A4.3): conflicting CVSS block threshold

- **Source location:** Section A2.2 "The Eight Canonical Pipeline Stages" (Stage 4 — Dependency
  & Container Scanning) vs. Section A4.3 "Compliance Gate Architecture" (gate table, row
  "Dependency").
- **Original statement (Section A2.2):** *"CVE severity gating (Critical = block, High = block
  if CVSS > 8.0)."*
- **Conflicting statement (Section A4.3):** *"Dependency | Trivy | 0 Critical CVE, SBOM
  generated | Pipeline blocked if CVSS ≥9.0 | 72h remediation window."*
- **Why it is incorrect:** Both sections describe the same gate (the Trivy dependency/container
  scan) but state two different High-severity CVSS blocking thresholds — 8.0 in the stage
  description and 9.0 in the compliance gate table. A single control cannot have two
  authoritative thresholds; one of the two values is the planted error.
- **Correct statement:** Adopt a single threshold and apply it consistently across both
  sections. This project's pipeline design standardises on **CVSS ≥ 8.0 blocks the build**
  (matching Section A2.2, the more detailed technical specification), and treats the 9.0 figure
  in Section A4.3 as the erroneous value to be corrected to 8.0.
- **Evidence:** Direct quotation comparison above, both drawn from the assessment PDF (page 4,
  Section A2.2; page 9, Section A4.3).
- **Where the correction is applied in this repo:** `docs/03-compliance-gates/compliance-gates.md`
  (dependency/container scan gate row) and the scanning thresholds documented consistently at
  CVSS ≥ 8.0.

---

## Error 2 — Part C (Cloudflare case study): incorrect outage duration

- **Source location:** Section "Case Study 3: Cloudflare Global Outage (Worldwide, July 2019)."
- **Original (erroneous) statement:** The assessment document's own errata note states: *"The
  original version of this document states the outage lasted 21 minutes."*
- **Why it is incorrect:** The real-world July 2, 2019 Cloudflare WAF-rule outage lasted
  approximately 27 minutes, not 21. The document's "What Happened" narrative and the
  "Rollback took 27 minutes" root-cause bullet both use the correct figure, but the *originally
  drafted* figure (21 minutes) is flagged in-document as the planted error.
- **Correct statement:** The Cloudflare outage on July 2, 2019 lasted **27 minutes**, consistent
  with both mentions in the case study body.
- **Evidence:** Assessment PDF, Case Study 3, page 28: *"NOTE: This case study contains a
  deliberate error in Part C. The original version of this document states the outage lasted 21
  minutes. The actual duration was 27 minutes."*
- **Where the correction is applied in this repo:** Referenced in
  `docs/06-rollback-specification/rollback-specification.md` as the supporting case for an
  independent, mesh-level rollback path that doesn't depend on the primary deploy mechanism.

---

## Error 3 — Part D (Section D1: Project Structure Overview): arithmetic inconsistency in effort estimate

- **Source location:** Section D1 "Project Structure Overview."
- **Original statement:** *"Total expected commitment: 6–9 hours per day, 100–135 hours over 15
  days."*
- **Why it is incorrect:** 15 days × 6 hours/day = 90 hours, and 15 days × 9 hours/day = 135
  hours. The stated range should be **90–135 hours**, not 100–135 hours. The lower bound (100)
  does not reconcile with the stated daily commitment (6 hrs/day × 15 days = 90 hrs) — a simple
  multiplication error.
- **Correct statement:** *"Total expected commitment: 6–9 hours per day, 90–135 hours over 15
  days."*
- **Evidence:** Assessment PDF, Section D1, page 32 — arithmetic check: 15 × 6 = 90 ≠ 100.
- **Where the correction is applied in this repo:** Noted here; the corrected range (90–135
  hours) is used as the reference effort estimate in `evidence/self-assessment.md`.

---

## Project implementation limitations

(Carried over from the original submission — these remain accurate and are kept for
transparency rather than removed.)

### Simulated deployment environments
The repository does not connect to an external Kubernetes cluster or production infrastructure.
Non-production deployment, progressive production deployment, DAST, smoke testing and
post-deployment verification are represented by validation/simulation steps rather than a live
environment. This is reflected honestly in `evidence/self-assessment.md`, where these stages are
labelled **Simulated**, not **Completed**.

### DAST limitation
A full dynamic scan requires a reachable running target. The project documents the intended DAST
gate and its blocking thresholds (`docs/03-compliance-gates/compliance-gates.md`), but a live
target must be supplied before treating this as a production DAST result.

### Progressive delivery limitation
The intended canary sequence (1% → 10% → 50% → 100%, with statistical promotion criteria) is
represented in the workflow and documentation. Actual weighted traffic shifting requires an
integrated platform such as Istio, Argo Rollouts, or an equivalent deployment controller, which
is outside the scope of this repository's CI demonstration.

### Coverage and policy controls
JaCoCo enforces the configured line (≥80%) and branch (≥70%) coverage thresholds in CI. Six
Helm-rendered manifest policies (`pipeline/policies/*.rego`) are checked by Conftest against the
repository's configured workload requirements.
>>>>>>> 6c5a403 (update in project)
