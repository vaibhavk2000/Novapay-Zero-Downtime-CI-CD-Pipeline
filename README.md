# NovaPay Zero-Downtime CI/CD Pipeline

## Overview

This project implements a multi-stage DevOps and Cloud Engineering CI/CD pipeline for **NovaPay**.

The pipeline is designed to validate source code, test application quality, perform security scanning, build and scan a container image, validate deployment policies, simulate environment promotion, perform deployment verification, and archive evidence.

The pipeline is implemented using **GitHub Actions** and is triggered on pushes and pull requests to the `main` branch.

---

# CI/CD Pipeline Architecture

The actual pipeline flow is:

```text
Git Push / Pull Request
        │
        ▼
┌─────────────────────────┐
│    Source Validation    │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Test and Coverage Gate  │
└────────────┬────────────┘
             │
             ├──────────────────────────┐
             │                          │
             ▼                          ▼
┌──────────────────┐          ┌──────────────────────┐
│ Secret Scanning  │          │ SAST and Code Quality│
└────────┬─────────┘          └──────────┬───────────┘
         │                               │
         │        ┌──────────────────────┘
         │        │
         ▼        ▼
   ┌──────────────────────────┐
   │ Dependency Security Scan │
   └────────────┬─────────────┘
                │
                ▼
┌──────────────────────────────────┐
│ Container Build and Security     │
│                                  │
│ • Build application JAR          │
│ • Build Docker image             │
│ • Generate security information  │
│ • Scan container image           │
└───────────────┬──────────────────┘
                │
                ▼
┌──────────────────────────────────┐
│ Policy and Compliance Validation │
│                                  │
│ • Helm validation                │
│ • Rego policies                  │
│ • Non-root validation            │
│ • Health probe validation        │
└───────────────┬──────────────────┘
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
┌───────────────────┐  ┌──────────────────┐
│ Deploy to         │  │ Evidence Archive │
│ Non-Production    │  └──────────────────┘
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ DAST and          │
│ Smoke Tests       │
└─────────┬─────────┘
          │
          ▼
┌──────────────────────────────┐
│ Progressive Production       │
│ Deployment                   │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ Post-Deployment Verification │
└──────────────────────────────┘
````

---

# Pipeline Stages

The GitHub Actions workflow contains the following stages.

| Stage                             | Purpose                                                          |
| --------------------------------- | ---------------------------------------------------------------- |
| Source Validation                 | Verifies required source and project files                       |
| Secret Scanning                   | Detects exposed secrets and sensitive information                |
| Test and Coverage Gate            | Builds and tests the Java application                            |
| SAST and Code Quality             | Performs static application security analysis                    |
| Dependency Security Scan          | Checks dependencies and filesystem vulnerabilities               |
| Container Build and Security      | Builds the Docker image and performs container security scanning |
| Policy and Compliance             | Validates Helm manifests against Rego policies                   |
| Deploy to Non-Production          | Performs non-production deployment validation                    |
| DAST and Smoke Tests              | Performs smoke and dynamic security validation                   |
| Progressive Production Deployment | Simulates progressive production rollout                         |
| Post-Deployment Verification      | Verifies deployment and rollback readiness                       |
| Evidence Archival                 | Stores generated reports and pipeline evidence                   |

---

# Technology Stack

## Application

* Java 21
* Spring Boot
* Gradle 8.8

## CI/CD

* GitHub Actions

## Containerization

* Docker

## Security

* Gitleaks
* Semgrep
* Trivy

## Policy as Code

* Open Policy Agent
* Rego
* Conftest

## Deployment Configuration

* Helm
* Kubernetes manifests

## Infrastructure

* Terraform

## Observability

* Grafana dashboard configuration

---

# Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci-pipeline.yml
│
├── app/
│   ├── build.gradle
│   └── settings.gradle
│
├── dashboards/
│   ├── grafana/
│   └── mockups/
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
├── evidence/
│   ├── screenshots/
│   ├── test-results/
│   ├── reflections.md
│   └── self-assessment.md
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
├── runbooks/
│   ├── deployment-runbook.md
│   └── incident-playbook.md
│
├── Dockerfile
├── ERRATA.md
└── README.md
```

---

# Pipeline Execution Flow

The pipeline begins when a developer pushes code or opens a pull request.

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ▼
Source Validation
    │
    ▼
Test and Coverage Gate
    │
    ▼
Security Validation
    ├── Secret Scanning
    ├── SAST and Code Quality
    └── Dependency Security Scan
    │
    ▼
Container Build and Security
    │
    ▼
Policy and Compliance Validation
    │
    ├──────────────► Evidence Archive
    │
    ▼
Non-Production Deployment
    │
    ▼
DAST and Smoke Tests
    │
    ▼
Progressive Production Deployment
    │
    ▼
Post-Deployment Verification
```

---

# Security and Quality Gates

The pipeline includes multiple validation gates.

## Secret Scanning

Secret scanning checks the repository for accidentally committed credentials, tokens, API keys, and other sensitive information.

## Test and Coverage

The application is built and tested using Gradle.

The pipeline validates application quality before allowing the next stages to proceed.

## SAST and Code Quality

Static analysis checks the application source code for potential security and quality issues.

## Dependency Security

Dependencies and project files are scanned for known vulnerabilities.

## Container Security

The application is packaged into a Docker image and scanned for vulnerabilities.

## Policy and Compliance

Helm and Kubernetes deployment configurations are validated against Rego policies.

The policies check requirements such as:

* Containers should not run as root.
* Deployments should include required health probes.

---

# Deployment Strategy

The deployment flow follows this sequence:

```text
Validated Build
       │
       ▼
Non-Production
       │
       ▼
Smoke Tests
       │
       ▼
DAST Validation
       │
       ▼
Progressive Production Deployment
       │
       ▼
Post-Deployment Verification
```

A deployment is promoted only after the required preceding stages complete successfully.

---

# Rollback Strategy

If deployment verification fails, the rollout should be stopped and the rollback procedure can be invoked.

The rollback script is located at:

```text
pipeline/scripts/rollback.sh
```

The pipeline also verifies that the rollback procedure is available during post-deployment verification.

---

# Evidence and Reporting

The project stores supporting assessment evidence in the following locations:

```text
evidence/
├── screenshots/
├── test-results/
├── reflections.md
└── self-assessment.md
```

Pipeline evidence and generated reports can also be uploaded as GitHub Actions artifacts.

---

# Running the Application Locally

Build the application:

```bash
cd app
gradle clean bootJar --no-daemon
```

The generated JAR can be found in:

```text
app/build/libs/
```

---

# Building the Docker Image

From the project root:

```bash
docker build -t novapay:latest .
```

Run the container:

```bash
docker run -p 8080:8080 novapay:latest
```

---

# Running the CI/CD Pipeline

The pipeline automatically runs when changes are pushed to the `main` branch or when a pull request targets `main`.

```text
Push / Pull Request
        ↓
GitHub Actions
        ↓
NovaPay CI/CD
```

Workflow file:

```text
.github/workflows/ci-pipeline.yml
```

---

# Project Outcome

The NovaPay project demonstrates an end-to-end DevOps pipeline containing:

* Automated source validation
* Application build and testing
* Security scanning
* Dependency scanning
* Container build and vulnerability scanning
* Policy-as-code validation
* Non-production deployment validation
* Smoke and DAST testing
* Progressive production deployment
* Post-deployment verification
* Rollback readiness validation
* Evidence archival

## Successful Pipeline

The complete pipeline has successfully executed all configured stages in GitHub Actions.

```text
Source Validation                 ✓
Secret Scanning                   ✓
Test and Coverage Gate            ✓
SAST and Code Quality             ✓
Dependency Security Scan          ✓
Container Build and Security      ✓
Policy and Compliance             ✓
Deploy to Non-Production          ✓
DAST and Smoke Tests              ✓
Progressive Production Deployment ✓
Post-Deployment Verification     ✓
Evidence Archival                 ✓
```

---

# Author

**Vaibhav Kunghatkar**

DevOps & Cloud Engineer Project
NovaPay Zero-Downtime CI/CD Pipeline
