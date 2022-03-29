auditLog:
  enabled: false

%{~ if provider == "azure" ~}
# AKS does not use docker anymore
docker:
  enabled: false

# Use EBPF instead of kernel module
ebpf:
  enabled: true
%{~ endif ~}

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
        (container.image.repository = "ghcr.io/fluxcd/notification-controller") or
        (container.image.repository = "ghcr.io/xenitab/git-auth-proxy") or
        (container.image.repository = "docker.io/grafana/loki") or
        (container.image.repository = "grafana/fluent-bit-plugin-loki") or
        (container.image.repository = "ghcr.io/xenitab/azad-kube-proxy") or
        (container.image.repository = "cr.l5d.io/linkerd/controller") or
        (container.image.repository = "mcr.microsoft.com/oss/azure/aad-pod-identity/nmi") or
        (container.image.repository = "quay.io/jetstack/cert-manager-cainjector") or
        (container.image.repository = "quay.io/jetstack/cert-manager-controller") or
        (container.image.repository = "quay.io/jetstack/cert-manager-webhook") or
        (container.image.repository = "docker.io/bitnami/external-dns") or
        (container.image.repository = "squat/configmap-to-disk") or
        (container.image.repository = "stakater/reloader") or
        (container.image.repository = "gcr.io/datadoghq/agent") or
        (container.image.repository = "quay.io/prometheus/prometheus") or
        (container.image.repository = "quay.io/prometheus-operator/prometheus-operator") or
        (container.image.repository = "k8s.gcr.io/ingress-nginx/controller") or
        (container.image.repository = "gcr.io/datadoghq/cluster-agent") or
        (container.image.repository = "public.ecr.aws/aws-secrets-manager/secrets-store-csi-driver-provider-aws") or
        (container.image.repository = "k8s.gcr.io/sig-storage/csi-node-driver-registrar") or
        (container.image.repository = "openpolicyagent/gatekeeper") or
        (container.image.repository = "quay.io/fairwinds/goldilocks") or
        (container.image.repository = "k8s.gcr.io/autoscaling/vpa-recommender") or
        (container.image.repository = "docker.io/bitnami/external-dns") or
        (container.image.repository = "docker.io/giantswarm/starboard-exporter") or
        (container.image.repository = "docker.io/aquasec/starboard-operator") or
        (container.image.repository = "k8s.gcr.io/autoscaling/cluster-autoscaler")

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
        (container.image.repository = "quay.io/prometheus/node-exporter") or
        (container.image.repository = "gcr.io/datadoghq/agent")

  # AKS tunnelfront writes in /etc
  rules_user_known_write_below_etc_activities.yaml: |-
    - macro: user_known_write_below_etc_activities
      condition: >
        (container.image.repository = "mcr.microsoft.com/aks/hcp/hcp-tunnel-front") or
        (container.image.repository = "gcr.io/datadoghq/agent")

  # Launch Privileged Container
  rules_launch_privileged_container.yaml: |-
    - macro: Launch Privileged Container
      condition: >
        (container.image.repository = "mcr.microsoft.com/oss/calico/node") or
        (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver") or
        (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/azuredisk-csi") or
        (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi") or
        (container.image.repository = "mcr.microsoft.com/oss/kubernetes/kube-proxy") or
        (container.image.repository = "602401143452.dkr.ecr.eu-west-1.amazonaws.com/eks/kube-proxy") or
        (container.image.repository = "k8s.gcr.io/sig-storage/csi-node-driver-registrar") or
        (container.image.repository = "k8s.gcr.io/dns/k8s-dns-node-cache") or
        (container.image.repository = "docker.io/falcosecurity/falco")

  macro_strange_mount.yaml: |-
    macro: strange_mount
      condition: (container.mount.dest[/../*] != "N/A")

  rule_launch_sensitive_volume_container.yaml: |-
    desc: >
      Detect the initial process started by a container that has a mount from a sensitive host directory
      (i.e. /proc). Exceptions are made for known trusted images.
    condition: >
      container_started and container
      and strange_mount
    output: Container with sensitive mount started (user=%user.name user_loginuid=%user.loginuid command=%proc.cmdline %container.info image=%container.image.repository:%container.image.tag mounts=%container.mounts)
    priority: INFO
    tags: [container, cis, mitre_lateral_movement]
