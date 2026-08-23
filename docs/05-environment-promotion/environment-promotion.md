# Deliverable 5 — Environment Promotion

| Environment | Purpose | Data | Promotion |
|---|---|---|---|
| Dev | fast feedback | synthetic | automatic |
| Staging | integration | masked/synthetic | gated |
| Pre-prod | production-like validation | masked | approval + evidence |
| Production | customer traffic | production | progressive + approval |

Configuration follows base → environment override → service override. Secrets are referenced through a secret-management system and are never committed.
