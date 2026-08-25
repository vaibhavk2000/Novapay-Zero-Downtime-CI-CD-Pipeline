# Deliverable 5 — Environment Promotion Workflow

## Environments

| Environment | Purpose | Data | Access | Trigger |
|---|---|---|---|---|
| Dev | developer integration | synthetic | engineering team | automated |
| Staging | integration validation | synthetic/anonymized | engineering/QA | successful CI |
| Pre-prod | production-like verification | masked/anonymized | restricted | approval gate |
| Production | customer service | production | tightly controlled | approved promotion |

## Promotion criteria

### Dev → Staging
- build, tests and configured security checks pass
- versioned artifact available
- environment configuration validates

### Staging → Pre-prod
- smoke/integration checks pass
- coverage and policy gates pass
- migration compatibility reviewed

### Pre-prod → Production
- change approval recorded
- rollback target verified
- monitoring and alerting available
- production deployment window approved
- no unresolved blocking security or policy findings

## Configuration hierarchy
`base → environment override → service override`

Secrets must not be stored in plain repository configuration. Production secrets should be injected by the platform's approved secret-management mechanism.

## RBAC
Separate developer, reviewer/approver, platform operator and production incident roles. The same identity should not silently bypass required controls.
