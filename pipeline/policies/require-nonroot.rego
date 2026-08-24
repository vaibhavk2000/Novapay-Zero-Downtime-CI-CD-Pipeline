package main

deny[msg] {
    input.kind == "Deployment"

    not input.spec.template.spec.securityContext.runAsNonRoot

    msg := "Deployment must run with runAsNonRoot set to true"
}