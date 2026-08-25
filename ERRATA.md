# ERRATA

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
