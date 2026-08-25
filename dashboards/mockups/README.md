# NovaPay Dashboard Mockups

## Purpose

This directory contains mockup designs and documentation for the NovaPay observability dashboard.

The dashboard is intended to provide a high-level view of application health, deployment status, performance, and operational metrics.

## Dashboard Overview

The NovaPay dashboard is designed to display the following information:

- Application availability
- Service health
- Request volume
- Error rate
- Response latency
- Deployment status
- Container health
- Security and operational indicators

## Key Metrics

### Application Health

The dashboard should monitor:

- Application readiness
- Application liveness
- Service availability

### Performance

Performance metrics include:

- Request count
- Average response time
- P95 and P99 latency

### Reliability

Reliability indicators include:

- HTTP error rate
- Successful request percentage
- Service availability

### Deployment Monitoring

Deployment information should include:

- Current application version
- Deployment status
- Deployment time
- Rollout progress
- Rollback status

## Mockup Purpose

The mockups in this directory demonstrate the intended dashboard layout before or alongside implementation in Grafana.

They provide a visual representation of how NovaPay operational data can be presented to engineers and operators.

## Related Dashboard

The implemented Grafana dashboard configuration is located at:

```text
dashboards/grafana/novapay-overview.json
