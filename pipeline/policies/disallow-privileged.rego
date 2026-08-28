package main

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    container.securityContext.privileged == true

    msg := sprintf(
        "Container '%s' must not run as privileged",
        [container.name]
    )
}
