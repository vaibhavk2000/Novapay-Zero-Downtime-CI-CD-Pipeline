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
<<<<<<< HEAD
=======

## Independence from the primary deployment path
Per the Cloudflare case study lesson (`ERRATA.md` Error 2 — the July 2019 outage took 27 minutes
to resolve specifically because rollback depended on the same control plane the faulty change had
degraded), NovaPay's rollback mechanism operates at the traffic-routing (mesh/ingress) layer
rather than depending on application health or the CI/CD control plane. See the rollback decision
flow diagram: `docs/02-deployment-strategies/diagrams/rollback-decision-flow.png`.

## Regulatory mapping
This specification implements RBI Master Direction §4.2 (change management — rollback
procedures) and §6.3 (incident management and business continuity). See
`docs/03-compliance-gates/compliance-gates.md` for the full RBI/PCI-DSS gate mapping.
>>>>>>> 6c5a403 (update in project)
