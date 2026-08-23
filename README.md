# NovaPay Zero-Downtime CI/CD Pipeline
## DevOps & Cloud Engineer Assessment

This repository contains the architecture, specifications, automation examples, policies, deployment strategies, runbooks and observability design for a regulated banking CI/CD platform.

## Deliverables
1. [Pipeline Architecture](docs/01-pipeline-architecture/architecture.md)
2. [Deployment Strategies](docs/02-deployment-strategies/deployment-strategies.md)
3. [Compliance Gates](docs/03-compliance-gates/compliance-gates.md)
4. [Database Migration](docs/04-database-migration/database-migration.md)
5. [Environment Promotion](docs/05-environment-promotion/environment-promotion.md)
6. [Rollback Specification](docs/06-rollback-specification/rollback-specification.md)
7. [Runbook & Playbook](docs/07-runbook-playbook/runbook-playbook.md)
8. [Observability](docs/08-observability/observability.md)

## Technology context
Java 21, Spring Boot 3.x, PostgreSQL 16, Redis 7, RabbitMQ 3.13, Kubernetes 1.29+, GitHub Actions, Terraform, Helm, Argo CD, Istio, Prometheus, Grafana, Loki, OpenTelemetry, SonarQube, OWASP ZAP, Trivy and OPA.

## Architecture summary
A change is validated, built and tested before security, supply-chain and policy gates. Passing artifacts are promoted through dev, staging, pre-production and production. Production uses progressive delivery with blue-green and canary strategies. Health, SLO and business-impact signals can stop promotion and trigger rollback.
