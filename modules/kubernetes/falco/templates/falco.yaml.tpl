apiVersion: v1
kind: Namespace
metadata:
 name: falco
 labels:
   name: falco
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: falco
  namespace: falco
spec:
  interval: 1m0s
  url: "https://falcosecurity.github.io/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: falco
  namespace: falco
spec:
  chart:
    spec:
      chart: falco
      sourceRef:
        kind: HelmRepository
        name: falco
      version: v4.17.2
  interval: 1m0s
  values:
    # Use EBPF instead of kernel module
    driver:
      kind: ebpf

    falcoctl:
      artifact:
        install:
          enabled: false
        follow:
          enabled: false

    falco:
      grpc:
        enabled: true
      grpc_output:
        enabled: true

      # This should be further explored in the future but seems
      # to be a bug right now with no fix so the solution is sadly
      # to ignore all syscall errors.
      # https://github.com/falcosecurity/falco/issues/1403
      syscallEventDrops:
        actions:
          - log

    podPriorityClassName: platform-high

    scc:
      # -- Create OpenShift's Security Context Constraint.
      create: false

    collectors:
      docker:
        enabled: false
      crio:
        enabled: false

    # -- Tolerations to allow Falco to run on Kubernetes masters.
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
      - effect: NoSchedule
        key: node-role.kubernetes.io/control-plane
      - operator: Exists

    customRules:
      # Applications which are expected to communicate with the Kubernetes API
      rules_user_known_k8s_api_callers.yaml: |-
        - macro: user_known_contact_k8s_api_server_activities
          condition: >
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
            (container.image.repository = "k8s.gcr.io/sig-storage/csi-node-driver-registrar") or
            (container.image.repository = "openpolicyagent/gatekeeper") or
            (container.image.repository = "quay.io/fairwinds/goldilocks") or
            (container.image.repository = "k8s.gcr.io/autoscaling/vpa-recommender") or
            (container.image.repository = "docker.io/bitnami/external-dns") or
            (container.image.repository = "docker.io/giantswarm/starboard-exporter") or
            (container.image.repository = "docker.io/aquasec/trivy-operator") or
            (container.image.repository = "k8s.gcr.io/autoscaling/cluster-autoscaler")

      # Applications which spawn a docker or kubectl client
      # Kustomize controller runs kubectl and kustomize
      # Tunnel front is expected to do this
      # https://github.com/Azure/AKS/issues/2087
      rules_user_known_k8s_client_container.yaml: |-
        - macro: user_known_k8s_client_container_parens
          condition: >
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
%{ if cilium_enabled == false }
            (container.image.repository = "mcr.microsoft.com/oss/calico/node") or
%{ endif }
            (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver") or
            (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/azuredisk-csi") or
            (container.image.repository = "mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi") or
            (container.image.repository = "mcr.microsoft.com/oss/kubernetes/kube-proxy") or
            (container.image.repository = "k8s.gcr.io/sig-storage/csi-node-driver-registrar") or
            (container.image.repository = "k8s.gcr.io/dns/k8s-dns-node-cache") or
            (container.image.repository = "docker.io/falcosecurity/falco")
