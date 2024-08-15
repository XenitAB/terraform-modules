apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: x509-certificate-exporter
  namespace: prometheus
spec:
  interval: 1m0s
  url: "https://charts.enix.io"
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
      version: 3.8.0
  interval: 1m0s
  values:
    secretsExporter:
      includeNamespaces:
        - prometheus
    priorityClassName: platform-medium
    prometheusRules:
      # We don't manage prometheus rules per cluster.
      create: false

    prometheusServiceMonitor:
      # We use serviceMonitors from another helm chart.
      create: false
