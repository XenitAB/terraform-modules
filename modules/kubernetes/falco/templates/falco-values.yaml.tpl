auditLog:
  enabled: false

# AKS does not use docker anymore
docker:
  enabled: false

# Use EBPF instead of kernel module
ebpf:
  enabled: true

falco:
  grpc:
    enabled: true
  grpcOutput:
    enabled: true

  # This should be further explored in the future but seems
  # to be a bug right now with no fix so the solution is sadly
  # to ignore all syscall errors.
  # https://github.com/falcosecurity/falco/issues/1403
  syscallEventDrops:
    actions:
      - log

priorityClassName: system-node-critical

customRules:
  rules_user_known_k8s_api_callers.yaml: |-
    - macro: user_known_contact_k8s_api_server_activities
      condition: >
        (container.image.repository = "docker.io/fluxcd/helm-operator") or
        (container.image.repository = "docker.io/fluxcd/flux") or
        (container.image.repository = "ghcr.io/fluxcd/kustomize-controller")
