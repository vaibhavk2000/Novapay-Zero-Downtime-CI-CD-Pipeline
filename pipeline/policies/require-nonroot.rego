package novapay.kubernetes
deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg := "runAsNonRoot is required"
}
