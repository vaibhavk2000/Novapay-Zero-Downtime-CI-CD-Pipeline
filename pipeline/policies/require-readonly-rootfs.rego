package main

deny[msg] {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    container := containers[_]

    container.securityContext.readOnlyRootFilesystem != true

    msg := sprintf(
        "Container '%s' must set securityContext.readOnlyRootFilesystem to true",
        [container.name]
    )
}
