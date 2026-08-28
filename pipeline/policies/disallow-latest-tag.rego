package main

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    endswith(container.image, ":latest")

    msg := sprintf(
        "Container '%s' must not use the ':latest' tag — pin to an immutable digest or semantic version for traceability (RBI Section 6.1)",
        [container.name]
    )
}

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    not contains(container.image, ":")

    msg := sprintf(
        "Container '%s' must specify an explicit image tag",
        [container.name]
    )
}
