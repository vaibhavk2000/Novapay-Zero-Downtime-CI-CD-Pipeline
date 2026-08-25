# CI/CD Deployment Runbook

## Purpose

This runbook describes the deployment and verification process for the NovaPay application through the GitHub Actions CI/CD pipeline.

## Pipeline Deployment Flow

The deployment process follows these stages:

1. Source validation
2. Application build with Java 21
3. Unit and integration testing
4. JaCoCo coverage verification
5. SAST and code-quality checks
6. Dependency and secret scanning
7. Container build
8. SBOM generation and image security scanning
9. Policy and compliance validation
10. Non-production deployment
11. Smoke testing and DAST validation
12. Progressive production deployment
13. Post-deployment verification
14. Evidence archival

## Non-Production Deployment

Before deployment, the following checks must pass:

- Application build
- Unit tests
- Coverage gate
- Security scans
- Container image scan
- Kubernetes policy validation

The non-production stage validates the deployment configuration and represents deployment of the NovaPay application using the generated container image.

## Smoke Testing

After non-production deployment, verify:

- Application readiness
- Application liveness
- Health endpoint availability

A failed verification must block further promotion.

## DAST Validation

A full DAST scan requires a running and accessible target environment.

The pipeline includes a DAST validation stage. When a live non-production URL is available, this stage can be extended to perform a full dynamic security scan against the deployed application.

## Progressive Production Deployment

Production rollout follows a progressive deployment approach:

1. Canary deployment
2. Health verification
3. Traffic expansion
4. Full promotion

If verification fails during rollout, promotion must stop and the rollback procedure should be initiated.

## Post-Deployment Verification

Verify the following after deployment:

- Application readiness
- Application liveness
- Error rate
- Response latency
- Availability of the rollback procedure

## Rollback Procedure

The rollback script is located at:

```text
pipeline/scripts/rollback.sh
