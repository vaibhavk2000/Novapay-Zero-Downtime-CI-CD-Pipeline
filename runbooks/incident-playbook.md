# NovaPay Incident Playbook

## Purpose

This playbook defines the response procedure when a CI/CD pipeline, deployment, security gate, or post-deployment verification fails.

## Incident Detection

An incident may be detected through:

- Failed GitHub Actions workflow
- Failed test or coverage gate
- Failed security scan
- Failed container image scan
- Failed policy validation
- Failed deployment verification
- Failed smoke test
- Production health check failure

## Severity Levels

### Severity 1 - Critical

Examples:

- Production deployment failure
- Application unavailable
- Critical security vulnerability
- Major data or service impact

Action:

1. Stop the deployment.
2. Freeze further promotion.
3. Initiate rollback.
4. Investigate the root cause.
5. Record the incident.

### Severity 2 - High

Examples:

- Security gate failure
- Policy validation failure
- High-severity container vulnerability
- Failed post-deployment verification

Action:

1. Block promotion.
2. Investigate the failure.
3. Fix the issue.
4. Re-run the pipeline.

### Severity 3 - Medium

Examples:

- Test failure
- Coverage threshold failure
- Dependency issue

Action:

1. Stop the pipeline at the failed stage.
2. Identify the failing component.
3. Apply the required fix.
4. Run tests locally or through CI.
5. Push the corrected change.

## CI/CD Failure Response

### Build Failure

1. Review the GitHub Actions logs.
2. Identify compilation or dependency errors.
3. Correct the application or Gradle configuration.
4. Commit and push the fix.
5. Confirm the build passes.

### Test or Coverage Gate Failure

The project requires:

- Line coverage >= 80%
- Branch coverage >= 70%

If the coverage gate fails:

1. Review the JaCoCo report.
2. Identify uncovered code.
3. Add or improve unit tests.
4. Re-run the coverage verification.
5. Confirm that the required thresholds pass.

### Security Scan Failure

If Gitleaks, Semgrep, or Trivy detects a blocking issue:

1. Stop promotion.
2. Review the security finding.
3. Remove secrets or vulnerable components.
4. Update dependencies if required.
5. Re-run the pipeline.
6. Confirm the security gate passes.

### Policy Validation Failure

If Conftest/Rego policy validation fails:

1. Review the failed policy.
2. Check the rendered Kubernetes manifests.
3. Correct the Helm templates or configuration.
4. Confirm required security controls are present.

Current policy requirements include:

- Containers must run as non-root.
- Deployments must define a liveness probe.
- Deployments must define a readiness probe.

### Deployment Failure

If a deployment stage fails:

1. Stop further promotion.
2. Check deployment logs and configuration.
3. Verify the container image.
4. Verify Helm configuration.
5. Correct the issue.
6. Re-run deployment verification.

## Rollback Procedure

The rollback script is located at:

```text
pipeline/scripts/rollback.sh
