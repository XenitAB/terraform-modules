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

priorityClassName: platform-high

customRules:
  # Applications which are expected to communicate with the Kubernetes API
  rules_user_known_k8s_api_callers.yaml: |-
    - macro: user_known_contact_k8s_api_server_activities
      condition: >
        (container.image.repository = "docker.io/fluxcd/helm-operator") or
        (container.image.repository = "docker.io/fluxcd/flux") or
        (container.image.repository = "ghcr.io/fluxcd/kustomize-controller") or
        (container.image.repository = "ghcr.io/fluxcd/helm-controller") or
        (container.image.repository = "docker.io/grafana/loki") or
        (container.image.repository = "grafana/fluent-bit-plugin-loki") or
        (container.image.repository = "ghcr.io/xenitab/azad-kube-proxy") or
        (container.image.repository = "cr.l5d.io/linkerd/controller") or
        (container.image.repository = "mcr.microsoft.com/oss/azure/aad-pod-identity/nmi") or
        (container.image.repository = "quay.io/jetstack/cert-manager-cainjector") or
        (container.image.repository = "docker.io/bitnami/external-dns") or
        (container.image.repository = "squat/configmap-to-disk") or
        (container.image.repository = "stakater/reloader") or
        (container.image.repository = "bloomberg/goldpinger")


  # Applications which spawn a docker or kubectl client
  # Kustomize controller runs kubectl and kustomize
  # Tunnel front is expected to do this
  # https://github.com/Azure/AKS/issues/2087
  rules_user_known_k8s_client_container.yaml: |-
    - macro: user_known_k8s_client_container_parens
      condition: >
        (container.image.repository = "docker.io/fluxcd/helm-operator") or
        (container.image.repository = "docker.io/fluxcd/flux") or
        (container.image.repository = "ghcr.io/fluxcd/kustomize-controller") or
        (container.image.repository = "mcr.microsoft.com/aks/hcp/hcp-tunnel-front")


  # Sensitive mounts in containers
  # AKS uses a different kube-proxy image
  # Node exporter has to mount sensitive paths
  rules_user_sensitive_mount_containers.yaml: |-
    - macro: user_sensitive_mount_containers
      condition: >
        (container.image.repository = "mcr.microsoft.com/oss/kubernetes/kube-proxy") or
        (container.image.repository = "quay.io/prometheus/node-exporter")

  # AKS tunnelfront writes in /etc
  rules_user_known_write_below_etc_activities.yaml: |-
    - macro: user_known_write_below_etc_activities
      condition: >
        (container.image.repository = "mcr.microsoft.com/aks/hcp/hcp-tunnel-front")
