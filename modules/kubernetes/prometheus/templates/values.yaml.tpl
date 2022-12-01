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

# We do not control the API Server so there is little value to monitor it.
# Additionally metrics like apiserver_request_duration_seconds_bucket and apiserver_request_slo_duration_seconds_bucket produce large amounts of timeseries.
# If this is enabled only the metrics that are actually needed should be kept. All other metrics should be dropped.
kubeApiServer:
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

# We don't monitor the clusters locally
defaultRules:
  create: false

prometheusOperator:
  priorityClassName: "platform-low"

prometheus-node-exporter:
  priorityClassName: "platform-high"
  prometheus:
    monitor:
      additionalLabels:
        xkf.xenit.io/monitoring: platform
