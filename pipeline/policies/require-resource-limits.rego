package main

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    not container.resources.limits.cpu

    msg := sprintf(
        "Container '%s' must define resources.limits.cpu",
        [container.name]
    )
}

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    not container.resources.limits.memory

    msg := sprintf(
        "Container '%s' must define resources.limits.memory",
        [container.name]
    )
}
