# ERRATA

## Project Notes and Corrections

### 1. Simulated Deployment Environments

The CI/CD pipeline includes stages for non-production deployment, progressive production deployment, DAST, smoke testing, and post-deployment verification.

For this project submission, these stages are implemented as pipeline validation and simulation steps because no external Kubernetes cluster or production infrastructure is connected to the repository.

The pipeline architecture and workflow sequencing remain representative of the intended production CI/CD process.

### 2. DAST Validation

A full Dynamic Application Security Testing scan requires a running and externally accessible application environment.

Therefore, the current DAST stage validates the deployment security stage and documents the requirement for a live target environment.

### 3. Progressive Production Deployment

The progressive production deployment stage demonstrates the intended rollout sequence:

1. Canary deployment
2. Health verification
3. Traffic expansion
4. Full promotion

The current implementation simulates these phases because a live production environment is not configured.

### 4. Coverage Quality Gate

The project implements JaCoCo coverage verification with the following thresholds:

- Minimum line coverage: 80%
- Minimum branch coverage: 70%

A pipeline failure occurs if the configured coverage thresholds are not satisfied.

### 5. Policy Validation

Kubernetes policy validation is performed using Helm-rendered manifests and Conftest/Rego policies.

The policies verify:

- Containers run as non-root
- Liveness probes are configured
- Readiness probes are configured

## Conclusion

These notes document the project implementation decisions and environment limitations. All implemented CI/CD pipeline stages were successfully validated in GitHub Actions.
