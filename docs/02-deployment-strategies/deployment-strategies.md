# Deliverable 2 — Blue-Green and Canary Deployment Strategy

## Objective
NovaPay requires a deployment design that minimizes customer disruption and provides a fast return to a known-good release. The strategy combines blue-green deployment for deterministic environment switching with a phased canary rollout for risk-controlled exposure.

## Blue-Green topology
Two production-compatible environments are maintained:

- **Blue**: currently serving stable traffic.
- **Green**: receives the candidate release while isolated from customer traffic.
- **Traffic layer**: an Istio VirtualService or equivalent routing component controls which environment receives production traffic.
- **Shared services**: database and Redis-backed session state must remain compatible with both application versions during the transition.

### Five-step traffic switching protocol
1. Deploy the candidate version to the inactive environment.
2. Wait for startup, liveness and readiness checks to succeed.
3. Execute smoke tests and compatibility checks against the inactive environment.
4. Drain long-running requests from the active environment and switch traffic to the verified candidate.
5. Observe error rate, latency, saturation and payment success metrics while retaining the previous environment as the rollback target.

If a blocking metric is breached, traffic is returned to the previous stable environment.

## Canary rollout
A canary rollout limits initial customer exposure and promotes only when each observation period remains healthy.

| Phase | Traffic | Minimum checks |
|---|---:|---|
| 1 | 1% | readiness, smoke tests, error rate |
| 2 | 10% | baseline latency and error comparison |
| 3 | 50% | sustained saturation and downstream health |
| 4 | 100% | final production verification |

### Suggested promotion thresholds
- HTTP 5xx rate: stop and investigate when the canary materially exceeds the approved baseline; immediate rollback for a severe sustained breach.
- p95/p99 latency: halt promotion when regression exceeds the service SLO or agreed baseline tolerance.
- Readiness: all required replicas must be ready before the next phase.
- Payment success: no statistically meaningful degradation against the control population.
- Resource saturation: CPU, memory, connection pool and downstream dependency saturation must remain within operating limits.

## Statistical comparison
For a mature implementation, compare control and canary latency samples using Welch's t-test and compare error proportions using a proportion/chi-squared approach where sample size assumptions are satisfied. Statistical output supports a decision; it does not replace SLO and safety gates.

## Session and transaction safety
Session state should be externalized to a distributed store such as Redis so that traffic can move without depending on pod-local session memory. Long-running payment operations must support graceful shutdown and connection draining. New pods receive traffic only after readiness succeeds; terminating pods stop receiving new requests before their configured grace period expires.

## Rollback guarantee
The previous stable environment or stable ReplicaSet remains available until post-deployment verification succeeds. Database changes follow the expand-contract strategy described in Deliverable 4 so an application rollback is not blocked by an incompatible schema.
