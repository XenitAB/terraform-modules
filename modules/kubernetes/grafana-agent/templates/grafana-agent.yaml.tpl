apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: grafana-agent-operator
  namespace: grafana-agent
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: grafana-agent-operator
  namespace: grafana-agent
spec:
  chart:
    spec:
      chart: grafana-agent-operator
      sourceRef:
        kind: HelmRepository
        name: grafana-agent-operator
      version: v0.3.21
  interval: 1m0s
  values:
    resources:
      requests:
        cpu: 25m
        memory: 80Mi
      limits:
        memory: 256Mi
    kubeletService:
      namespace: grafana-agent
    serviceAccount:
      name: grafana-agent