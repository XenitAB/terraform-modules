apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: x509-certificate-exporter
  namespace: prometheus
spec:
  interval: 1m0s
  url: "https://prometheus-community.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: x509-certificate-exporter
  namespace: prometheus
spec:
  chart:
    spec:
      chart: x509-certificate-exporter
      sourceRef:
        kind: HelmRepository
        name: x509-certificate-exporter
      version: 3.6.0
  interval: 1m0s
  values:
    secretsExporter:
      includeNamespaces:
        - prometheus

    prometheusRules:
      # We don't manage prometheus rules per cluster.
      create: false

    prometheusServiceMonitor:
      # We use serviceMonitors from another helm chart.
      create: false
