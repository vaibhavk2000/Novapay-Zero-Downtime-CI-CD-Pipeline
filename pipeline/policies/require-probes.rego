package main

deny contains msg if {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    some container in containers

    not container.livenessProbe

    msg := sprintf(
        "Container '%s' must define a livenessProbe",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    containers := input.spec.template.spec.containers

    some container in containers

    not container.readinessProbe

    msg := sprintf(
        "Container '%s' must define a readinessProbe",
        [container.name]
    )
}