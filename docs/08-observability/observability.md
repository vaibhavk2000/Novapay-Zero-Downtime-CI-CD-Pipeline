# Deliverable 8 — Observability and Dashboards

## DORA metrics
1. Deployment frequency
2. Lead time for changes
3. Change failure rate
4. Time to restore service

## Pipeline and service metrics
Track at least:
1. workflow duration
2. queue time
3. build duration
4. test duration
5. test pass rate
6. line coverage
7. branch coverage
8. SAST findings
9. dependency findings
10. secret findings
11. container findings
12. policy failures
13. deployment duration
14. deployment frequency
15. rollback count
16. HTTP 5xx rate
17. p95 latency
18. p99 latency
19. readiness failures
20. error-budget burn

## Dashboard views
### Engineering
Real-time pipeline state, deployment health, latency, error rate, saturation and rollback activity.

### Management
Weekly/monthly DORA trends, delivery throughput, change failure rate and recovery time.

### Regulatory/audit
Gate decisions, approvals, exceptions, artifact/image identity, timestamps and evidence references.

## Alerting
Route alerts by severity. Critical alerts page the responsible on-call path; lower severity alerts create tracked work. Alerts should include service, version, environment, observed metric, threshold and runbook reference.
