apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: grafana-k8s-monitoring
  namespace: grafana-k8s-monitoring
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: grafana-k8s-monitoring
  namespace: grafana-k8s-monitoring
spec:
  interval: 1m0s
  chart:
    spec:
      chart: k8s-monitoring
      sourceRef:
        kind: HelmRepository
        name: grafana-k8s-monitoring
      version: 1.4.8
  values:
    cluster:
      name: "${cluster_name}"
    externalServices:
      prometheus:
        host: "${grafana_k8s_monitor_config.grafana_cloud_prometheus_host}"
        secret:
          create: false
          name: prometheus-grafana-cloud
          namespace: grafana-k8s-monitoring
      loki:
        host: "${grafana_k8s_monitor_config.grafana_cloud_loki_host}"
        secret:
          create: false
          name: loki-grafana-cloud
          namespace: grafana-k8s-monitoring
      tempo:
        host: "${grafana_k8s_monitor_config.grafana_cloud_tempo_host}"
        secret:
          create: false
          name: tempo-grafana-cloud
          namespace: grafana-k8s-monitoring
    metrics:
      enabled: true
      alloy:
        metricsTuning:
          useIntegrationAllowList: true
      cost:
        enabled: true
      kepler:
        enabled: true
      node-exporter:
        enabled: true
    logs:
      enabled: true
      pod_logs:
        enabled: true
      cluster_events:
        enabled: true
    traces:
      enabled: true
    receivers:
      grpc:
        enabled: true
      http:
        enabled: true
      zipkin:
        enabled: true
      grafanaCloudMetrics:
        enabled: false
    opencost:
      enabled: true
      opencost:
        exporter:
          defaultClusterId: "${cluster_name}"
        prometheus:
        existingSecretName: prometheus-grafana-cloud
          external:
            url: "${grafana_k8s_monitor_config.grafana_cloud_prometheus_host}"
    kube-state-metrics:
      enabled: true
    prometheus-node-exporter:
      enabled: true
    prometheus-operator-crds:
      enabled: true
    kepler:
      enabled: true
    alloy: {}
    alloy-events: {}
    alloy-logs: {}
