# Deliverable 3 — Compliance Gates

1. Test coverage gate
2. SAST/code-quality gate
3. Secret detection gate
4. Dependency vulnerability gate
5. Container vulnerability gate
6. Kubernetes policy gate
7. DAST gate
8. Audit-evidence gate

Every exception requires an owner, approver, expiry time, rationale and evidence ID. Exceptions expire automatically and are re-evaluated.

## Audit record
Each gate produces JSON evidence containing build ID, commit SHA, timestamp, tool, result, threshold, exception ID and approver where applicable.

## Policy examples
See `pipeline/policies/`.
