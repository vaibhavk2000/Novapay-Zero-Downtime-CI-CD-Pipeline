#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${1:-production}"
APP="${2:-novapay}"
echo "Rolling back ${APP} in ${NAMESPACE}"
kubectl rollout undo deployment/"${APP}" -n "${NAMESPACE}"
kubectl rollout status deployment/"${APP}" -n "${NAMESPACE}" --timeout=120s
