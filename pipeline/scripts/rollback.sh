#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-novapay}"
RELEASE="${RELEASE:-novapay}"
MODE="${1:-helm}"

echo "======================================"
echo "NovaPay Rollback Procedure Started"
echo "Namespace: ${NAMESPACE}"
echo "Release: ${RELEASE}"
echo "Mode: ${MODE}"
echo "======================================"

case "${MODE}" in
  helm)
    PREVIOUS_REVISION="${PREVIOUS_REVISION:-}"
    if [[ -z "${PREVIOUS_REVISION}" ]]; then
      echo "ERROR: Set PREVIOUS_REVISION to the approved stable Helm revision."
      exit 1
    fi
    helm rollback "${RELEASE}" "${PREVIOUS_REVISION}" --namespace "${NAMESPACE}" --wait --timeout 5m
    ;;
  kubectl)
    kubectl rollout undo "deployment/${RELEASE}" --namespace "${NAMESPACE}"
    kubectl rollout status "deployment/${RELEASE}" --namespace "${NAMESPACE}" --timeout=5m
    ;;
  *)
    echo "Usage: $0 [helm|kubectl]"
    exit 2
    ;;
esac

echo "Running post-rollback verification..."
kubectl get pods --namespace "${NAMESPACE}" -l "app.kubernetes.io/name=${RELEASE}"
echo "Rollback completed. Execute the environment smoke test before closing the incident."
