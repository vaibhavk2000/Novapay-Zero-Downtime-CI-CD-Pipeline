# Deliverable 6 — Rollback Specification

## Category A — Immediate, target <60 seconds
Examples:
1. readiness failure after deployment
2. critical health endpoint failure
3. severe sustained HTTP 5xx increase
4. critical dependency failure directly caused by the release
5. unsafe version/configuration mismatch

Action: freeze promotion, route away from the candidate or undo the rollout, then verify the stable version.

## Category B — Escalated, target <15 minutes
Examples:
1. sustained p99 latency regression
2. connection-pool exhaustion
3. increasing downstream timeout rate
4. resource saturation with customer impact

Action: alert the incident owner, correlate release and infrastructure signals, and decide rollback or mitigation within the escalation target.

## Category C — Manual decision
Use when data integrity, external settlement, or business/regulatory impact requires an incident-command decision.

## Eight-step execution
1. Detect.
2. Correlate.
3. Freeze further promotion.
4. Select rollback target.
5. Execute rollback.
6. Verify health and smoke tests.
7. Notify stakeholders and record the incident.
8. Complete postmortem and corrective actions.

## Post-rollback verification
Compare error rate, latency, saturation and customer-impact indicators with the pre-release baseline. Confirm stable pod readiness and successful smoke transactions before closing the rollback.
