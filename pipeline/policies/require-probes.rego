package main

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    not container.livenessProbe

    msg := sprintf(
        "Container '%s' must define a livenessProbe",
        [container.name]
    )
}

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    not container.readinessProbe

    msg := sprintf(
        "Container '%s' must define a readinessProbe",
        [container.name]
    )
}