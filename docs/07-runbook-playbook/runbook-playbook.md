# Deliverable 7 — Runbook and Incident Playbook

This deliverable is implemented through:
- `runbooks/deployment-runbook.md`
- `runbooks/incident-playbook.md`

## Evidence checklist
Before deployment, capture:
1. approved change/version
2. successful CI run
3. artifact/image digest
4. security and policy results
5. migration compatibility decision
6. rollback target
7. monitoring availability
8. named deployment/incident owner

## Severity model
Define four levels in the incident playbook:
- Sev 1: critical customer or regulatory impact
- Sev 2: major service degradation
- Sev 3: limited degradation
- Sev 4: minor issue or investigation

Response targets, communication channels and escalation owners must be maintained by the operating team.
