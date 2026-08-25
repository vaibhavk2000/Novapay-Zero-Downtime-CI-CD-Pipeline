# Deliverable 4 — Zero-Downtime Database Migration

## Strategy: expand → migrate → switch → contract

### 1. Expand
Add backward-compatible structures without removing existing columns or behavior. Both App V(N-1) and App V(N) must continue to operate.

### 2. Migrate/backfill
Populate new structures in throttled batches. Record progress and stop or reduce throughput when database latency, locks or replication lag exceed operational limits.

### 3. Switch
Release application logic that can read/write the new structure. Prefer dual-read/dual-write or a controlled feature switch only while compatibility is required.

### 4. Contract
Remove old structures only after all supported application versions and rollback windows no longer depend on them.

## Compatibility matrix

| Schema state | App V(N-1) | App V(N) |
|---|---|---|
| Before expand | supported | not yet deployed |
| Expanded | supported | supported |
| During migrate | supported | supported |
| Switched | compatibility-dependent | supported |
| Contracted | retired | supported |

## Governance
- DBA or designated database owner approves production migrations.
- Migration review checks locking behavior, index creation, rollback, backup and application compatibility.
- Migration execution records operator, timestamp, version and result.
- Destructive changes require a separate change window after the compatibility period.

## Backfill
Use ordered batches with checkpoints. Avoid a single transaction for large tables. Throttle between batches and make the job restartable and idempotent where possible.

## Rollback
Application rollback should remain possible through the expand and migrate phases. If a migration itself must be reversed, use a separately reviewed compensating migration rather than assuming every DDL operation is safely reversible.
