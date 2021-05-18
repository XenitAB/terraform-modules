# For more values see: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
# grafana is managed by the grafana-operator
grafana:
  enabled: false

kubeControllerManager:
  enabled: false

kubeScheduler:
  enabled: false

# We don't use alert manager in the cluster, we use thanos ruler
alertmanager:
  enabled: false

prometheus:
  enabled: false

kube-state-metrics:
  podSecurityPolicy:
    enabled: false

commonLabels:
  xkf.xenit.io/monitoring: platform

global:
  rbac:
    pspEnabled: false

# We don't monitor the clusters locally
defaultRules:
  create: false

prometheus-node-exporter:
  nodeExporter:
    priorityClassName: "platform-high"
