package main

deny contains msg if {
    input.kind == "Deployment"

    pod_security := input.spec.template.spec.securityContext

    not pod_security.runAsNonRoot

    msg := "Deployment must run with runAsNonRoot set to true"
}