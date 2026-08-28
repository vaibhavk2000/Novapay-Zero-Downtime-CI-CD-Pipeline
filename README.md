# NovaPay Zero-Downtime CI/CD Pipeline

## Overview

This project implements a **multi-stage DevOps and Cloud Engineering CI/CD pipeline** for **NovaPay Digital Bank**, a fictional RBI-licensed digital banking platform.

The project demonstrates how a financial-services application can move from manual deployment processes to an **automated, security-first, compliance-gated, zero-downtime delivery model** using modern DevOps practices.

The pipeline is implemented using **GitHub Actions** and is triggered on:

* Pushes to the `main` branch
* Pull requests targeting the `main` branch

The pipeline validates source code, runs automated tests, enforces code coverage, performs security scanning, builds and scans a container image, generates an SBOM, validates Kubernetes deployment policies, and progresses through documented deployment and verification stages.

> **Important:** This repository clearly distinguishes between stages that execute against real tooling in CI and stages that are simulated/documented because a live Kubernetes cluster, service mesh, or reachable DAST target is not included in the repository.

---

# Architecture

The NovaPay CI/CD pipeline follows a sequential and gated delivery model.

```text
                         ┌───────────────────────┐
                         │Git Push / Pull Request│
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │  Source Validation    │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ Test & Coverage Gate  │
                         │ Java 21 / Gradle 8.8  │
                         └───────────┬───────────┘
                                     │
                       ┌─────────────┴─────────────┐
                       │                           │
                       ▼                           ▼
             ┌───────────────────┐      ┌────────────────────┐
             │ Secret Scanning   │      │ SAST / Code Quality│
             │    Gitleaks       │      │      Semgrep       │
             └─────────┬─────────┘      └──────────┬─────────┘
                       │                           │
                       └─────────────┬─────────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ Dependency Security   │
                         │        Trivy          │
                         └───────────┬───────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Container Security              │
                    │                                 │
                    │ • Build Application JAR         │
                    │ • Build Docker Image            │
                    │ • Generate SBOM                 │
                    │ • Scan Container Image          │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Policy & Compliance Validation  │
                    │                                 │
                    │ • Helm Template Rendering       │
                    │ • 6 Rego Policies               │
                    │ • Conftest Validation           │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Non-Production Deployment       │
                    │        Simulated                │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ DAST + Smoke Tests              │
                    │        Simulated                │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Progressive Production          │
                    │ Deployment / Canary             │
                    │        Simulated                │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Post-Deployment Verification    │
                    │        Simulated                │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │ Evidence Archival               │
                    └─────────────────────────────────┘
```

The architecture diagram is available at:

```text
docs/01-pipeline-architecture/diagrams/
└── novapay-cicd-architecture.png
```

---

# Pipeline Stages

## 1. Source Validation

The first stage validates the repository before expensive build and security operations begin.

Checks include:

* Repository structure
* Required application files
* Dockerfile
* Helm chart
* Policy directory
* Accidental private-key material

A failure prevents subsequent stages from executing.

---

## 2. Test and Coverage Gate

The application is built using:

* Java 21
* Gradle 8.8
* Spring Boot

Automated tests are executed using Gradle.

JaCoCo is used to generate code coverage reports.

### Coverage thresholds

| Metric          | Minimum |
| --------------- | ------: |
| Line Coverage   |     80% |
| Branch Coverage |     70% |

The pipeline fails when either threshold is not satisfied.

---

## 3. Secret Scanning

**Gitleaks** is used to identify accidentally committed secrets.

Examples of secrets that should not be committed include:

* API keys
* Passwords
* Tokens
* Private keys
* Cloud credentials
* Database credentials

The secret scanning stage is treated as a mandatory security gate.

---

## 4. SAST and Code Quality

**Semgrep** performs static application security testing.

The scan is intended to identify:

* Security vulnerabilities
* Unsafe coding patterns
* Injection risks
* Suspicious application behavior
* Security-sensitive Java code

The pipeline fails if configured Semgrep rules report blocking findings.

---

## 5. Dependency Security Scan

**Trivy** scans the repository for dependency and secret-related vulnerabilities.

Critical and high-severity findings are treated as blocking findings when they meet the configured scan criteria.

This provides an automated software supply-chain security check before container creation.

---

# 6. Container Build and Security

After application tests and security checks pass, the application JAR is generated.

The pipeline then:

1. Builds the Java application.
2. Creates the Docker image.
3. Generates an SBOM.
4. Scans the container image.

The image is tagged using the Git commit SHA.

Example:

```text
novapay:<git-commit-sha>
```

This provides immutable identification of the build artifact.

---

# 7. SBOM Generation

An SBOM is generated using **Anchore SBOM Action**.

The SBOM provides visibility into software components included in the container.

The generated SBOM is stored as a GitHub Actions artifact.

The SBOM format used by the pipeline is:

```text
CycloneDX JSON
```

---

# 8. Container Image Scanning

The final Docker image is scanned using **Trivy**.

The pipeline checks for:

* Critical vulnerabilities
* High-severity vulnerabilities
* Vulnerable operating-system packages
* Vulnerable application dependencies

The container security stage must pass before the deployment policy stage can begin.

---

# 9. Policy and Compliance Validation

Kubernetes resources are generated using **Helm**.

The pipeline renders the Helm chart:

```bash
helm template novapay pipeline/helm/novapay
```

The resulting Kubernetes manifests are then validated using:

* Open Policy Agent
* Rego
* Conftest

Six policy-as-code gates are maintained under:

```text
pipeline/policies/
```

The policy stage is designed to prevent insecure Kubernetes configurations from reaching deployment stages.

---

# Policy Gates

The six policy gates cover deployment security requirements such as:

* Non-root containers
* Required security context
* Readiness/liveness probes
* Resource requests and limits
* Secure container configuration
* Kubernetes deployment standards

All six policies must pass before the pipeline can continue.

---

# 10. Non-Production Deployment

The repository contains the deployment configuration required for a non-production environment.

However, this submission does not include a live Kubernetes cluster.

Therefore, the GitHub Actions workflow represents the non-production deployment as a **simulated/documented deployment gate**.

The intended real deployment flow is:

```text
CI Artifact
     │
     ▼
Non-Production Kubernetes
     │
     ▼
Deployment
     │
     ▼
Readiness Validation
     │
     ▼
Smoke Tests
```

---

# 11. DAST and Smoke Testing

Dynamic Application Security Testing is intended to run against a deployed non-production application.

The complete implementation would require a reachable application endpoint.

Because this repository does not provide a live deployment target, the DAST stage is currently:

**Simulated / Documented**

The intended checks include:

* HTTP availability
* Health endpoint
* Authentication behavior
* Authorization behavior
* Security headers
* Application errors
* API response validation
* Basic security scanning

---

# 12. Zero-Downtime Deployment Strategy

NovaPay uses a combination of **blue-green** and **canary deployment concepts**.

## Blue-Green Deployment

Two environments are maintained conceptually:

```text
              ┌───────────────┐
              │   Production  │
              └───────┬───────┘
                      │
                 Traffic
                      │
               ┌──────▼──────┐
               │    BLUE     │
               │ Current     │
               │ Version     │
               └─────────────┘

               ┌─────────────┐
               │    GREEN    │
               │ New Version │
               └─────────────┘
```

The new version is deployed to Green while Blue continues serving traffic.

After validation, traffic can be shifted to Green.

---

# Canary Deployment

The progressive rollout model is:

```text
5% → 25% → 50% → 100%
```

At each stage, application health and business metrics should be evaluated.

If the new release performs incorrectly, traffic is rolled back to the previous stable version.

The live traffic-shifting mechanism is not executed in this repository because a service mesh or equivalent production routing infrastructure is not included.

---

# 13. Post-Deployment Verification

The intended post-deployment verification checks include:

* Application availability
* Readiness status
* Liveness status
* HTTP 5xx rate
* Application error rate
* Request latency
* Database connectivity
* Critical business transaction
* Infrastructure health
* Resource utilization

The repository documents these checks, but does not execute them against a live production cluster.

---

# 14. Rollback Strategy

NovaPay includes a rollback specification and rollback script.

Location:

```text
pipeline/scripts/rollback.sh
```

Rollback can be triggered by three broad categories:

### Category 1 — Application Failure

Examples:

* High error rate
* Application crashes
* Failed health checks
* Critical functional regression

### Category 2 — Infrastructure Failure

Examples:

* Kubernetes deployment failure
* Pod instability
* Resource exhaustion
* Networking problems

### Category 3 — Security / Compliance Failure

Examples:

* Newly discovered critical vulnerability
* Security policy violation
* Compliance gate failure
* Unauthorized configuration

The rollback decision flow is documented under:

```text
docs/06-rollback-specification/
```

---

# Database Migration Strategy

NovaPay uses an **expand-contract database migration approach**.

The migration is divided into five phases:

```text
Phase 1
Expand
   ↓
Phase 2
Backwards-Compatible Application
   ↓
Phase 3
Data Migration
   ↓
Phase 4
Application Cutover
   ↓
Phase 5
Contract
```

The migration design prevents application downtime by maintaining compatibility between application versions during the transition.

Detailed documentation is available under:

```text
docs/04-database-migration/
```

---

# Environment Promotion

The intended promotion model is:

```text
Development
     │
     ▼
Testing
     │
     ▼
Non-Production
     │
     ▼
Production
```

Each environment has progressively stronger validation requirements.

Production promotion requires successful completion of the preceding gates.

Documentation:

```text
docs/05-environment-promotion/
```

---

# Compliance and Governance

The project includes a compliance-gate mapping for:

* RBI Master Direction requirements
* PCI-DSS v4.0 controls

The mapping connects pipeline controls with security and governance requirements.

Examples include:

| Pipeline Control  | Security Objective               |
| ----------------- | -------------------------------- |
| Source validation | Change integrity                 |
| Gitleaks          | Secret protection                |
| Semgrep           | Secure coding                    |
| Trivy             | Vulnerability management         |
| SBOM              | Software supply-chain visibility |
| Rego policies     | Deployment governance            |
| Approval gates    | Controlled promotion             |
| Evidence archival | Auditability                     |
| Rollback          | Operational resilience           |

Detailed mapping:

```text
docs/03-compliance-gates/
```

> The compliance mapping in this project is an engineering demonstration and should not be interpreted as legal, regulatory, or audit certification.

---

# Infrastructure as Code

Terraform configuration is maintained under:

```text
pipeline/terraform/
```

The Terraform configuration provides the foundation for Kubernetes-related infrastructure used by the project.

The repository intentionally separates infrastructure provisioning from application deployment.

---

# Helm Deployment

The NovaPay Kubernetes deployment is packaged as a Helm chart.

Location:

```text
pipeline/helm/novapay/
```

Typical structure:

```text
pipeline/
└── helm/
    └── novapay/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
```

Helm is responsible for generating Kubernetes manifests consistently across environments.

---

# Repository Structure

```text
.
├── README.md
├── ERRATA.md
├── Dockerfile
│
├── app/
│   ├── build.gradle
│   ├── settings.gradle
│   └── src/
│       ├── main/
│       └── test/
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
├── pipeline/
│   ├── helm/
│   │   └── novapay/
│   ├── policies/
│   │   ├── require-nonroot.rego
│   │   ├── require-probes.rego
│   │   └── ...
│   ├── scripts/
│   │   └── rollback.sh
│   └── terraform/
│
├── runbooks/
│   ├── deployment-runbook.md
│   └── incident-playbook.md
│
├── dashboards/
│   ├── grafana/
│   └── mockups/
│
├── evidence/
│   ├── trc-presentation.pdf
│   ├── self-assessment.md
│   ├── reflections.md
│   ├── screenshots/
│   └── test-results/
│
└── .github/
    └── workflows/
        └── ci-pipeline.yml
```

---

# Tools and Technologies

| Category               | Technology     |
| ---------------------- | -------------- |
| CI/CD                  | GitHub Actions |
| Programming Language   | Java 21        |
| Application Framework  | Spring Boot    |
| Build Tool             | Gradle 8.8     |
| Testing                | JUnit / Gradle |
| Coverage               | JaCoCo         |
| Secret Scanning        | Gitleaks       |
| SAST                   | Semgrep        |
| Dependency Scanning    | Trivy          |
| Container Scanning     | Trivy          |
| SBOM                   | Anchore        |
| Policy-as-Code         | OPA / Rego     |
| Policy Validation      | Conftest       |
| Kubernetes Packaging   | Helm           |
| Infrastructure as Code | Terraform      |
| Container              | Docker         |
| Diagrams               | Mermaid        |

---

# Getting Started

## Prerequisites

Install the following tools if you want to run the project locally:

```text
Java 21
Gradle 8.8
Docker
Helm
Conftest
Git
```

Optional:

```text
Terraform
Trivy
Semgrep
Gitleaks
```

---

# Build the Application

Navigate to the application directory:

```bash
cd app
```

Run:

```bash
gradle clean build test jacocoTestReport --no-daemon
```

Generate the test and coverage reports:

```bash
gradle test jacocoTestReport --no-daemon
```

---

# Render Kubernetes Manifests

From the repository root:

```bash
helm template novapay pipeline/helm/novapay > rendered-manifests.yaml
```

Review the generated file:

```bash
cat rendered-manifests.yaml
```

---

# Run Policy Validation Locally

Run:

```bash
conftest test rendered-manifests.yaml \
  --policy pipeline/policies
```

All six Rego policies must pass.

---

# Build the Docker Image

From the repository root:

```bash
docker build -t novapay:local .
```

Verify the image:

```bash
docker images | grep novapay
```

---

# Scan the Docker Image

If Trivy is installed locally:

```bash
trivy image novapay:local
```

For blocking high and critical vulnerabilities:

```bash
trivy image \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  novapay:local
```

---

# Run the CI/CD Pipeline

The GitHub Actions workflow is located at:

```text
.github/workflows/ci-pipeline.yml
```

The workflow is triggered by:

```text
Push → main
```

or:

```text
Pull Request → main
```

The pipeline executes the available real validation stages and then proceeds through the documented/simulated deployment gates.

---

# Pipeline Execution Model

The workflow uses job dependencies to create security gates.

Conceptually:

```text
Source
  ↓
Tests
  ↓
Security
  ↓
Container
  ↓
Policy
  ↓
Non-Prod
  ↓
DAST
  ↓
Production
  ↓
Verification
  ↓
Evidence
```

A failed mandatory gate prevents promotion to the next stage.

---

# Observability and DORA Metrics

The project includes an observability design covering:

* Deployment Frequency
* Lead Time for Changes
* Change Failure Rate
* Mean Time to Recovery

These are the four primary DORA metrics used to evaluate delivery performance.

Additional application metrics include:

* Request rate
* Error rate
* Latency
* Availability
* Resource utilization
* Deployment health

Documentation:

```text
docs/08-observability/
```

---

# Runbooks

Operational procedures are maintained under:

```text
runbooks/
```

Available documents include:

```text
runbooks/
├── deployment-runbook.md
└── incident-playbook.md
```

The deployment runbook describes the expected deployment process.

The incident playbook describes response procedures for deployment and application incidents.

---

# Evidence and Auditability

Pipeline evidence is maintained under:

```text
evidence/
```

The evidence package contains:

```text
evidence/
├── trc-presentation.pdf
├── self-assessment.md
├── reflections.md
├── screenshots/
└── test-results/
```

Evidence is intended to demonstrate:

* Pipeline execution
* Security gates
* Test results
* Coverage
* Policy validation
* Deployment decisions
* Governance
* Risk assessment

---

# Real vs Simulated Components

Transparency is an important part of this project.

## Executed for Real in CI

The following stages use real tools and execute in GitHub Actions:

* Source validation
* Java 21 setup
* Gradle build
* Unit tests
* JaCoCo coverage
* Gitleaks
* Semgrep
* Trivy filesystem scan
* Docker image build
* SBOM generation
* Trivy container scan
* Helm rendering
* Conftest
* Six Rego policy checks

## Simulated / Documented

The following stages are represented as controlled validation gates but are not connected to live infrastructure:

* Non-production Kubernetes deployment
* Live smoke tests
* DAST against a deployed endpoint
* Canary traffic shifting
* Blue-green production traffic switching
* Production deployment
* Post-deployment production verification

The reason is that this repository does not include:

* A live Kubernetes cluster
* Production credentials
* A service mesh
* A reachable DAST endpoint
* Production infrastructure

This distinction is intentionally documented rather than presenting simulated functionality as production-ready infrastructure.

---

# Security Principles

The project follows a defense-in-depth approach.

```text
Source
  ↓
Secret Security
  ↓
Code Security
  ↓
Dependency Security
  ↓
Container Security
  ↓
SBOM
  ↓
Policy Security
  ↓
Deployment Security
  ↓
Runtime Verification
```

Security checks are integrated into the delivery pipeline rather than being performed only after deployment.

---

# Zero-Downtime Principles

The deployment architecture is designed around the following principles:

1. Backward-compatible database changes
2. Immutable application artifacts
3. Automated health validation
4. Progressive traffic shifting
5. Automated rollback capability
6. Pre-deployment security gates
7. Post-deployment verification
8. Audit evidence collection

These controls reduce the risk of application downtime during releases.

---

# Deliberate Errors and Errata

The project includes three deliberate technical findings identified during assessment.

Evidence and explanations are documented in:

```text
ERRATA.md
```

The purpose is to demonstrate the ability to identify, document, and remediate technical risks rather than hiding them.

---

# Self-Assessment

The project includes an honest assessment of implementation status:

```text
evidence/self-assessment.md
```

The assessment distinguishes between:

```text
Completed
```

and:

```text
Simulated
```

This avoids claiming that infrastructure-dependent deployment stages are live when they are not.

---

# Technology Risk Committee

A Technology Risk Committee presentation is included at:

```text
evidence/trc-presentation.pdf
```

The presentation summarizes:

* Architecture
* Security controls
* Deployment strategy
* Compliance
* Risks
* Rollback
* Observability
* Implementation status

---

# Project Objectives

The main objectives of this project are to demonstrate:

* Automated CI/CD
* Secure software delivery
* Infrastructure-as-code practices
* Kubernetes deployment governance
* Policy-as-code
* Container security
* SBOM generation
* Compliance-aware pipelines
* Zero-downtime deployment strategies
* Progressive delivery
* Automated rollback design
* Operational observability
* Audit evidence collection

---

# Limitations

This repository is a DevOps/Cloud Engineering demonstration rather than a production banking platform.

The following are outside the scope of the repository:

* Real customer banking data
* Real RBI licensing
* Production banking infrastructure
* Production credentials
* Live payment processing
* Real customer authentication
* Live Kubernetes infrastructure
* Production service mesh
* Production database
* Live DAST endpoint

NovaPay is a fictional application used to demonstrate engineering and governance practices.

---

# Future Improvements

Potential future enhancements include:

* Connect to a managed Kubernetes cluster
* Add Argo CD or another GitOps platform
* Implement a service mesh
* Execute real canary traffic shifting
* Integrate Prometheus and Grafana
* Integrate production-grade DAST
* Add automated database migrations
* Add signed container images
* Implement image provenance/attestations
* Add admission-controller enforcement
* Add runtime security monitoring
* Add automated production rollback
* Integrate centralized audit logging

---

# Conclusion

NovaPay demonstrates a **security-first, compliance-aware, zero-downtime CI/CD architecture** suitable as a reference implementation for a regulated financial-services environment.

The pipeline combines:

```text
GitHub Actions
      +
Java 21 / Gradle
      +
Automated Testing
      +
JaCoCo
      +
Gitleaks
      +
Semgrep
      +
Trivy
      +
Docker
      +
SBOM
      +
Helm
      +
OPA / Rego / Conftest
      +
Terraform
      +
Progressive Deployment
      +
Rollback
      +
Observability
      +
Evidence
```

The result is a structured delivery pipeline where **quality, security, compliance, deployment safety, and auditability are treated as mandatory parts of software delivery**.

```
```
