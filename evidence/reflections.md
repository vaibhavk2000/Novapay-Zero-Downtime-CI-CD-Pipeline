# NovaPay CI/CD Project Reflections

## Project Overview

This project involved designing and implementing a CI/CD pipeline for the NovaPay application. The objective was to create a structured DevOps workflow that includes application build, automated testing, coverage validation, security scanning, container security, policy validation, deployment stages, verification, and evidence archival.

## Key Learnings

During this project, I gained practical experience with GitHub Actions and automated CI/CD workflows.

The main areas of learning included:

- Designing multi-stage CI/CD pipelines
- Building a Java application using Gradle
- Configuring Java 21 and Gradle in GitHub Actions
- Creating automated unit tests
- Implementing JaCoCo code coverage reporting
- Enforcing line and branch coverage quality gates
- Performing secret scanning
- Performing static application security testing
- Scanning dependencies for vulnerabilities
- Building and scanning Docker container images
- Generating a Software Bill of Materials (SBOM)
- Using Helm to render Kubernetes manifests
- Using Conftest and Rego for policy validation
- Designing deployment verification and rollback processes
- Archiving pipeline evidence

## Challenges Faced

Several issues were encountered during the implementation.

### Gradle Configuration

Initially, the GitHub Actions workflow could not find the Gradle wrapper. The pipeline was updated to use the configured Gradle version directly through the Gradle GitHub Action.

A Gradle compatibility issue was also encountered during the application build. Pinning the workflow to the working Gradle version resolved the issue.

### Rego Policy Errors

The policy validation stage initially failed because of Rego syntax and unsafe variable errors.

The policies were corrected to use compatible syntax, and Helm manifests were rendered before being passed to Conftest.

This ensured that the policies were evaluated against actual Kubernetes Deployment manifests.

### Coverage Gate

The pipeline architecture required:

- Line coverage >= 80%
- Branch coverage >= 70%

Tests and JaCoCo configuration were added to the project to generate coverage reports and enforce these thresholds.

The coverage gate prevents promotion when the required quality standards are not satisfied.

## Final Outcome

The final CI/CD pipeline successfully implements multiple DevOps and security gates.

The completed workflow includes:

1. Source validation
2. Secret scanning
3. Application build using Java 21
4. Automated testing
5. Code coverage verification
6. SAST and code quality checks
7. Dependency vulnerability scanning
8. Docker image build
9. SBOM generation
10. Container image scanning
11. Helm manifest rendering
12. Policy and compliance validation
13. Non-production deployment stage
14. Smoke testing and DAST validation
15. Progressive production deployment stage
16. Post-deployment verification
17. Evidence archival

## Conclusion

This project provided practical experience in building an end-to-end CI/CD workflow and integrating quality, security, compliance, and deployment verification into the software delivery process.

The final implementation demonstrates how automated pipeline gates can prevent unsuitable changes from progressing to later stages and how evidence can be preserved for review and verification.
