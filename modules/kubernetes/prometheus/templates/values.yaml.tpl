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
