# Deliverable 1 — Pipeline Architecture

## Pipeline stages
1. Source validation and signed-change checks
2. Build with Java 21
3. Unit and integration tests
4. Coverage gate: line >= 80%, branch >= 70%
5. SAST and code-quality gate
6. Dependency and secret scanning
7. Container build, SBOM generation and image scan
8. Policy/compliance-as-code gate
9. Deploy to non-production
10. DAST and smoke tests
11. Progressive production deployment
12. Post-deployment verification and evidence archival

## Failure path
A failed quality or security gate blocks promotion. A failed production verification freezes rollout and invokes rollback according to Deliverable 6.

## Parallelisation
SAST, secret scanning and dependency scanning may execute after checkout/build inputs are available. Artifact publication occurs only after mandatory gates pass.

## SLA targets
Fast feedback stages target completion within minutes. Security and DAST stages may run in parallel where isolation permits.
