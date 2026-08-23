# Deliverable 4 — Zero-Downtime Database Migration

## Expand
Add backward-compatible schema objects without removing existing columns.

## Migrate
Backfill in throttled batches and monitor locks, lag and error rate.

## Verify
Compare old/new representations and application compatibility.

## Contract
Remove deprecated objects only after all supported application versions no longer require them.

## Compatibility
| Application | Old schema | Expanded schema | Contracted schema |
|---|---|---|---|
| V(N-1) | yes | yes | no |
| V(N) | yes | yes | yes after migration |
