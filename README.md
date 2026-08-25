# NovaPay – DevOps and Cloud Engineering CI/CD Project

## Overview

NovaPay is a sample payment service used to demonstrate the design and implementation of a secure, automated CI/CD pipeline.

This project integrates application development, automated testing, code coverage, security scanning, containerization, policy-as-code, deployment validation, rollback planning, observability, and evidence collection.

The CI/CD pipeline is implemented using GitHub Actions and is designed around a quality and security gate approach. A failure in a mandatory stage prevents promotion to later stages.

---

## CI/CD Pipeline

The NovaPay pipeline includes the following stages:

1. Source validation
2. Secret scanning
3. Application build using Java 21
4. Unit and integration testing
5. Code coverage verification
6. SAST and code-quality scanning
7. Dependency vulnerability scanning
8. Docker container build
9. SBOM generation
10. Container image security scanning
11. Helm manifest rendering
12. Policy and compliance validation
13. Non-production deployment validation
14. Smoke testing and DAST validation
15. Progressive production deployment
16. Post-deployment verification
17. Evidence archival

### Pipeline Flow

```text
Source Validation
        |
        v
Application Build
        |
        +-------------------+-------------------+
        |                   |                   |
        v                   v                   v
      Tests               SAST          Dependency Scan
        |                   |                   |
        +-------------------+-------------------+
                            |
                            v
              Container Build + SBOM + Scan
                            |
                            v
                     Policy Validation
                            |
                            v
                Non-Production Deployment
                            |
                            v
                    Smoke Tests / DAST
                            |
                            v
             Progressive Production Deployment
                            |
                            v
              Post-Deployment Verification
                            |
                            v
                    Evidence Archival
```

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Java 21 | Application runtime |
| Spring Boot | Application framework |
| Gradle 8.8 | Build automation |
| GitHub Actions | CI/CD automation |
| JUnit | Automated testing |
| JaCoCo | Code coverage verification |
| Gitleaks | Secret scanning |
| Semgrep | Static application security testing |
| Trivy | Dependency and container security scanning |
| Docker | Containerization |
| SBOM | Software component inventory |
| Helm | Kubernetes application packaging |
| Conftest | Policy validation |
| Rego | Policy-as-code |
| Terraform | Infrastructure configuration |
| Grafana | Observability dashboard configuration |

---

## Quality Gate

The project enforces code coverage requirements using JaCoCo.

| Coverage Type | Minimum Required |
|---|---:|
| Line Coverage | 80% |
| Branch Coverage | 70% |

If either coverage threshold is not satisfied, the pipeline fails and promotion is blocked.

---

## Security Controls

The pipeline includes multiple security gates:

- Secret scanning using Gitleaks
- Static Application Security Testing using Semgrep
- Dependency vulnerability scanning using Trivy
- Docker container image scanning
- SBOM generation
- Kubernetes policy validation using Conftest and Rego

Security or compliance failures block further pipeline progression.

---

## Policy Validation

Kubernetes manifests are rendered using Helm before policy evaluation.

The project includes policies that verify:

- Containers run as non-root
- Deployments include a liveness probe
- Deployments include a readiness probe

Policy files are located in:

```text
pipeline/policies/
```

Helm resources are located in:

```text
pipeline/helm/novapay/
```

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci-pipeline.yml
│
├── app/
│   ├── src/
│   │   ├── main/
│   │   └── test/
│   ├── build.gradle
│   └── settings.gradle
│
├── pipeline/
│   ├── helm/
│   │   └── novapay/
│   ├── policies/
│   │   ├── require-nonroot.rego
│   │   └── require-probes.rego
│   ├── scripts/
│   │   └── rollback.sh
│   └── terraform/
│       └── main.tf
│
├── docs/
│   ├── 01-pipeline-architecture/
│   ├── 02-deployment-strategies/
│   ├── 03-compliance-gates/
│   ├── 04-database-migration/
│   ├── 05-environment-promotion/
│   ├── 06-rollback-specification/
│   ├── 07-runbook-playbook/
│   └── 08-observability/
│
├── dashboards/
│   ├── grafana/
│   └── mockups/
│
├── runbooks/
│   ├── deployment-runbook.md
│   └── incident-playbook.md
│
├── evidence/
│   ├── screenshots/
│   ├── test-results/
│   ├── reflections.md
│   └── self-assessment.md
│
├── Dockerfile
├── ERRATA.md
└── README.md
```

---

## Running the Application

Navigate to the application directory:

```bash
cd app
```

Build the application:

```bash
gradle clean build
```

Run the application:

```bash
gradle bootRun
```

---

## Running Tests

Run the automated tests:

```bash
cd app
gradle test --no-daemon
```

Generate the JaCoCo coverage report:

```bash
gradle jacocoTestReport --no-daemon
```

Verify the coverage quality gate:

```bash
gradle jacocoTestCoverageVerification --no-daemon
```

---

## Docker

Build the Docker image:

```bash
docker build -t novapay:latest .
```

Run the container:

```bash
docker run -p 8080:8080 novapay:latest
```

---

## CI/CD Workflow

The GitHub Actions workflow is located at:

```text
.github/workflows/ci-pipeline.yml
```

The workflow automatically runs on:

- Push to `main`
- Push to `release/**`
- Pull requests targeting `main`

---

## Deployment Strategy

The pipeline follows a progressive promotion model:

```text
Development
     |
     v
Quality and Security Gates
     |
     v
Non-Production
     |
     v
Smoke Testing / DAST
     |
     v
Progressive Production Deployment
     |
     v
Post-Deployment Verification
```

Production rollout follows the planned stages:

1. Canary deployment
2. Health verification
3. Traffic expansion
4. Full promotion

If a mandatory verification fails, promotion should stop and the rollback procedure should be followed.

---

## Rollback

The rollback procedure is documented and supported through:

```text
pipeline/scripts/rollback.sh
```

Additional operational instructions are available in:

```text
runbooks/deployment-runbook.md
runbooks/incident-playbook.md
```

---

## Observability

The project includes observability documentation and dashboard configuration.

Grafana dashboard configuration:

```text
dashboards/grafana/novapay-overview.json
```

Dashboard mockup documentation:

```text
dashboards/mockups/README.md
```

The observability design focuses on:

- Application availability
- Readiness and liveness
- Request volume
- Error rate
- Response latency
- Deployment status
- Rollback status

---

## Evidence

Pipeline and project evidence are organized under:

```text
evidence/
```

This includes:

- Successful pipeline screenshots
- Test and coverage evidence
- Project reflections
- Self-assessment
- Pipeline artifacts

---

## Documentation

Detailed documentation is available in the `docs/` directory.

Key documents include:

- Pipeline architecture
- Deployment strategies
- Compliance gates
- Database migration strategy
- Environment promotion
- Rollback specification
- Runbooks and playbooks
- Observability design

---

## Project Status

**Status: Completed**

The NovaPay CI/CD pipeline successfully integrates automated build, testing, coverage verification, security scanning, container security, policy validation, deployment stages, post-deployment verification, and evidence archival.

---

## Author

**Vaibhav Kunghatkar**

DevOps / Cloud Engineering Project
