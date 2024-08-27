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
  chart:
    spec:
      chart: k8s-monitoring
      sourceRef:
        kind: HelmRepository
        name: k8s-monitoring
      version: 1.4.8
  values:
    cluster:
      name: "${grafana_k8s_monitor_config.cluster_name}"
    externalServices:
      prometheus:
        host: "${grafana_k8s_monitor_config.grafana_cloud_prometheus_host}"
        basicAuth:
          username: "${grafana_k8s_monitor_config.grafana_cloud_prometheus_username}"
          password: "${grafana_k8s_monitor_config.grafana_cloud_api_key}"
      loki:
        host: "${grafana_k8s_monitor_config.grafana_cloud_loki_host}"
        basicAuth:
          username: "${grafana_k8s_monitor_config.grafana_cloud_loki_username}"
          password: "${grafana_k8s_monitor_config.grafana_cloud_api_key}"
      tempo:
        host: "${grafana_k8s_monitor_config.grafana_cloud_tempo_host}"
        basicAuth:
          username: "${grafana_k8s_monitor_config.grafana_cloud_tempo_username}"
          password: "${grafana_k8s_monitor_config.grafana_cloud_api_key}"
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
          defaultClusterId: "${grafana_k8s_monitor_config.cluster_name}"
        prometheus:
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
