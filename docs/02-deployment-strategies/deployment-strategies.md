# Deliverable 2 — Blue-Green and Canary

## Blue-Green
Deploy the candidate release to the inactive environment, run smoke and compatibility checks, drain long-running requests, switch traffic through Istio, verify key metrics, and retain the previous environment for immediate reversal.

## Canary
Suggested phases: 1%, 10%, 50%, 100%. At every phase compare error rate, p95/p99 latency and saturation against baseline. Promotion stops when thresholds are breached.

## Example thresholds
- HTTP 5xx rate: rollback if >5%
- p99 latency: halt when regression exceeds defined SLO
- pod readiness: all required replicas ready before promotion
- payment success/error metrics: no material regression

## Session and transaction safety
Redis-backed distributed session state and graceful shutdown reduce connection loss. New pods receive traffic only after readiness passes.
