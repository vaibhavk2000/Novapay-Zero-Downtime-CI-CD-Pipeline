# Stage Specifications
| Stage | Tool | Gate |
|---|---|---|
| Build | Gradle | compilation succeeds |
| Test | JUnit | tests pass |
| Coverage | JaCoCo | line >=80%, branch >=70% |
| SAST | SonarQube | quality gate passes |
| Secrets | Gitleaks | no unapproved secret |
| Dependencies | Trivy | no unapproved HIGH/CRITICAL |
| Container | Docker/BuildKit | reproducible image |
| Policy | OPA/Conftest | all required policies pass |
| DAST | OWASP ZAP | configured risk threshold passes |
