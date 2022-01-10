# For more values see: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
# grafana is managed by the grafana-operator
grafana:
  enabled: false

kubeControllerManager:
  enabled: false

kubeScheduler:
  enabled: false

kubeEtcd:
  enabled: false

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
  priorityClassName: "platform-low"
  podSecurityPolicy:
    enabled: false
  metricLabelsAllowlist:
    - "namespaces=[xkf.xenit.io/kind]"
  #selfMonitor:
  #  enabled: true
  prometheus:
    monitor:
      additionalLabels:
        xkf.xenit.io/monitoring: platform

commonLabels:
  xkf.xenit.io/monitoring: platform

global:
  rbac:
    pspEnabled: false

# We don't monitor the clusters locally
defaultRules:
  create: false

prometheusOperator:
  priorityClassName: "platform-low"

prometheus-node-exporter:
  priorityClassName: "platform-high"
