apiVersion: v1
kind: Namespace
metadata:
 name: prometheus
 labels:
   name: prometheus
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: prometheus
  namespace: prometheus
spec:
  interval: 1m0s
  url: "https://prometheus-community.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: prometheus
  namespace: prometheus
spec:
  chart:
    spec:
      chart: kube-prometheus-stack
      sourceRef:
        kind: HelmRepository
        name: prometheus
      version: 42.1.1
  interval: 1m0s
  values:
    # For more values see: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml

    # We do not monitor anything in clusters.
    defaultRules:
      create: false

    # Grafana is managed by the grafana-operator
    grafana:
      enabled: false

    kubeControllerManager:
      enabled: false

    kubeScheduler:
      enabled: false

    kubeEtcd:
      enabled: false

    kubeApiServer:
      enabled: true
      serviceMonitor:
        # The API Server generates a lot of metrics which are not useful in a managed Kubernetes cluster.
        # To reduce the metrics stored we dop everything except specific metrics.
        metricRelabelings:
          - action: keep
            regex: "kubernetes_build_info|apiserver_admission_.*"
            sourceLabels: [__name__]

    # Specific for AKS kube-proxy label
    kubeProxy:
      service:
        selector:
          component: kube-proxy

    # We don't use alert manager in the cluster, we use thanos ruler
    alertmanager:
      enabled: false

    prometheus:
      enabled: false

    kube-state-metrics:
      resources:
        requests:
          cpu: 15m
          memory: 50Mi
      priorityClassName: "platform-low"
      podSecurityPolicy:
        enabled: false
      metricLabelsAllowlist:
        - "namespaces=[xkf.xenit.io/kind]"
      collectors:
        # Disable collection of configmaps and secrets to reduce amount of metrics
        #- configmaps
        #- secrets
        - certificatesigningrequests
        - cronjobs
        - daemonsets
        - deployments
        - endpoints
        - horizontalpodautoscalers
        - ingresses
        - jobs
        - limitranges
        - mutatingwebhookconfigurations
        - namespaces
        - networkpolicies
        - nodes
        - persistentvolumeclaims
        - persistentvolumes
        - poddisruptionbudgets
        - pods
        - replicasets
        - replicationcontrollers
        - resourcequotas
        - services
        - statefulsets
        - storageclasses
        - validatingwebhookconfigurations
        - volumeattachments
      # Specificly add verticalpodautoscalers to collectors
      %{ if vpa_enabled }
        - verticalpodautoscalers # not a default resource, see also: https://github.com/kubernetes/kube-state-metrics#enabling-verticalpodautoscalers
      %{ endif }
      prometheus:
        monitor:
          additionalLabels:
            xkf.xenit.io/monitoring: platform

    commonLabels:
      xkf.xenit.io/monitoring: platform

    global:
      rbac:
        pspEnabled: false

    prometheusOperator:
      priorityClassName: "platform-low"

    prometheus-node-exporter:
      priorityClassName: "platform-high"
      prometheus:
        monitor:
          additionalLabels:
            xkf.xenit.io/monitoring: platform
