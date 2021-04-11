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
  prometheusSpec:
    serviceMonitorSelector:
      matchLabels:
       "xkf.xenit.io/monitoring": platform
    serviceMonitorNamespaceSelector:
      matchLabels:
       "xkf.xenit.io/kind": platform
    podMonitorSelector:
      matchLabels:
       "xkf.xenit.io/monitoring": platform
    podMonitorNamespaceSelector:
      matchLabels:
       "xkf.xenit.io/kind": platform
    probeSelector:
      matchLabels:
       "xkf.xenit.io/monitoring": platform
    probeNamespaceSelector:
      matchLabels:
       "xkf.xenit.io/kind": platform

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
