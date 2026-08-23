# Deliverable 6 — Automated Rollback

## Category A — immediate (<60 seconds)
Triggers include critical 5xx rate, readiness collapse, severe latency regression, crash loops and failed smoke checks.

## Category B — escalated (<15 minutes)
Triggers include rising saturation, connection-pool exhaustion, downstream timeout regression and SLO burn.

## Category C — manual decision
Business/regulatory decisions requiring incident command approval.

## Workflow
1. Detect
2. Correlate
3. Freeze promotion
4. Roll back traffic/workload
5. Verify service health
6. Notify stakeholders
7. Open incident
8. Complete postmortem
